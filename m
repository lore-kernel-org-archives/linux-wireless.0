Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0ASPhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 10:37:48 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 07:37:48 -0800
Date: Tue, 19 Jan 2010 07:37:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: make regulatory_hint_11d() band specific
Message-ID: <20100119153746.GB2133@tux>
References: <1263517700-21846-1-git-send-email-lrodriguez@atheros.com>
 <4B518D09.5080907@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4B518D09.5080907@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 16, 2010 at 01:55:21AM -0800, Benoit PAPILLAULT wrote:
> Luis R. Rodriguez a écrit :
> > In practice APs do not send country IE channel triplets for channels
> > the AP is not operating on and if they were to do so they would have
> > to use the regulatory extension which we currently do not process.
> > No AP has been seen in practice that does this though so just drop
> > those country IEs.
> >
> > Additionally it has been noted the first series of country IE
> > channels triplets are specific to the band the AP sends. Propagate
> > the band on which the country IE was found on reject the country
> > IE then if the triplets are ever oustide of the band.
> >
> > Although we now won't process country IE information with multiple
> > band information we leave the intersection work as is as it is
> > technically possible for someone to want to eventually process these
> > type of country IEs with regulatory extensions.
> >
> > Cc: Jouni Malinen <jouni.malinen@atheros.com>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >
> > This goes out tested now.
> >
> >  net/wireless/reg.c |   74 ++++++++++++++++++++++++++++++++++++++--------------
> >  net/wireless/reg.h |   11 +++++++
> >  net/wireless/sme.c |    1 +
> >  3 files changed, 66 insertions(+), 20 deletions(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 5b03ca7..7242121 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -485,6 +485,34 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
> >  }
> >
> >  /*
> > + * This is a work around for sanity checking ieee80211_channel_to_frequency()'s
> > + * work. ieee80211_channel_to_frequency() can for example currently provide a
> > + * 2 GHz channel when in fact a 5 GHz channel was desired. An example would be
> > + * an AP providing channel 8 on a country IE triplet when it sent this on the
> > + * 5 GHz band, that channel is designed to be channel 8 on 5 GHz, not a 2 GHz
> > + * channel.
> > + *
> > + * This can be removed once ieee80211_channel_to_frequency() takes in a band.
> > + */
> > +static bool chan_in_band(int chan, enum ieee80211_band band)
> > +{
> > +     int center_freq = ieee80211_channel_to_frequency(chan);
> > +
> > +     switch (band) {
> > +     case IEEE80211_BAND_2GHZ:
> > +             if (center_freq <= 2484)
> > +                     return true;
> > +             return false;
> > +     case IEEE80211_BAND_5GHZ:
> > +             if (center_freq >= 5005)
> > +                     return true;
> > +             return false;
> > +     default:
> > +             return false;
> > +     }
> > +}
> > +
> > +/*
> >   * Some APs may send a country IE triplet for each channel they
> >   * support and while this is completely overkill and silly we still
> >   * need to support it. We avoid making a single rule for each channel
> > @@ -532,7 +560,8 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
> >   * Returns 0 if the IE has been found to be invalid in the middle
> >   * somewhere.
> >   */
> > -static int max_subband_chan(int orig_cur_chan,
> > +static int max_subband_chan(enum ieee80211_band band,
> > +                         int orig_cur_chan,
> >                           int orig_end_channel,
> >                           s8 orig_max_power,
> >                           u8 **country_ie,
> > @@ -541,7 +570,6 @@ static int max_subband_chan(int orig_cur_chan,
> >       u8 *triplets_start = *country_ie;
> >       u8 len_at_triplet = *country_ie_len;
> >       int end_subband_chan = orig_end_channel;
> > -     enum ieee80211_band band;
> >
> >       /*
> >        * We'll deal with padding for the caller unless
> > @@ -557,17 +585,14 @@ static int max_subband_chan(int orig_cur_chan,
> >       *country_ie += 3;
> >       *country_ie_len -= 3;
> >
> > -     if (orig_cur_chan <= 14)
> > -             band = IEEE80211_BAND_2GHZ;
> > -     else
> > -             band = IEEE80211_BAND_5GHZ;
> > +     if (!chan_in_band(orig_cur_chan, band))
> > +             return 0;
> >
> >       while (*country_ie_len >= 3) {
> >               int end_channel = 0;
> >               struct ieee80211_country_ie_triplet *triplet =
> >                       (struct ieee80211_country_ie_triplet *) *country_ie;
> >               int cur_channel = 0, next_expected_chan;
> > -             enum ieee80211_band next_band = IEEE80211_BAND_2GHZ;
> >
> >               /* means last triplet is completely unrelated to this one */
> >               if (triplet->ext.reg_extension_id >=
> > @@ -592,6 +617,9 @@ static int max_subband_chan(int orig_cur_chan,
> >               if (triplet->chans.first_channel <= end_subband_chan)
> >                       return 0;
> >
> > +             if (!chan_in_band(triplet->chans.first_channel, band))
> > +                     return 0;
> > +
> >               /* 2 GHz */
> >               if (triplet->chans.first_channel <= 14) {
> >                       end_channel = triplet->chans.first_channel +
> > @@ -600,14 +628,10 @@ static int max_subband_chan(int orig_cur_chan,
> >               else {
> >                       end_channel =  triplet->chans.first_channel +
> >                               (4 * (triplet->chans.num_channels - 1));
> > -                     next_band = IEEE80211_BAND_5GHZ;
> >               }
> >
> > -             if (band != next_band) {
> > -                     *country_ie -= 3;
> > -                     *country_ie_len += 3;
> > -                     break;
> > -             }
> > +             if (!chan_in_band(end_channel, band))
> > +                     return 0;
> >
> >               if (orig_max_power != triplet->chans.max_power) {
> >                       *country_ie -= 3;
> > @@ -666,6 +690,7 @@ static int max_subband_chan(int orig_cur_chan,
> >   * with our userspace regulatory agent to get lower bounds.
> >   */
> >  static struct ieee80211_regdomain *country_ie_2_rd(
> > +                             enum ieee80211_band band,
> >                               u8 *country_ie,
> >                               u8 country_ie_len,
> >                               u32 *checksum)
> > @@ -743,8 +768,11 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> >               if (triplet->chans.num_channels == 0)
> >                               return NULL;
> >
> > +             if (!chan_in_band(triplet->chans.first_channel, band))
> > +                     return NULL;
> > +
> >               /* 2 GHz */
> > -             if (triplet->chans.first_channel <= 14)
> > +             if (band == IEEE80211_BAND_2GHZ)
> >                       end_channel = triplet->chans.first_channel +
> >                               triplet->chans.num_channels - 1;
> >               else
> > @@ -767,7 +795,8 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> >                * or for whatever reason sends triplets with multiple channels
> >                * separated when in fact they should be together.
> >                */
> > -             end_channel = max_subband_chan(cur_channel,
> > +             end_channel = max_subband_chan(band,
> > +                                            cur_channel,
> >                                              end_channel,
> >                                              triplet->chans.max_power,
> >                                              &country_ie,
> > @@ -775,6 +804,9 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> >               if (!end_channel)
> >                       return NULL;
> >
> > +             if (!chan_in_band(end_channel, band))
> > +                     return NULL;
> > +
> >               cur_sub_max_channel = end_channel;
> >
> >               /* Basic sanity check */
> > @@ -867,14 +899,15 @@ static struct ieee80211_regdomain *country_ie_2_rd(
> >               reg_rule->flags = flags;
> >
> >               /* 2 GHz */
> > -             if (triplet->chans.first_channel <= 14)
> > +             if (band == IEEE80211_BAND_2GHZ)
> >                       end_channel = triplet->chans.first_channel +
> >                               triplet->chans.num_channels -1;
> >               else
> >                       end_channel =  triplet->chans.first_channel +
> >                               (4 * (triplet->chans.num_channels - 1));
> >
> > -             end_channel = max_subband_chan(triplet->chans.first_channel,
> > +             end_channel = max_subband_chan(band,
> > +                                            triplet->chans.first_channel,
> >                                              end_channel,
> >                                              triplet->chans.max_power,
> >                                              &country_ie,
> > @@ -1981,8 +2014,9 @@ static bool reg_same_country_ie_hint(struct wiphy *wiphy,
> >   * therefore cannot iterate over the rdev list here.
> >   */
> >  void regulatory_hint_11d(struct wiphy *wiphy,
> > -                     u8 *country_ie,
> > -                     u8 country_ie_len)
> > +                      enum ieee80211_band band,
> > +                      u8 *country_ie,
> > +                      u8 country_ie_len)
> >  {
> >       struct ieee80211_regdomain *rd = NULL;
> >       char alpha2[2];
> > @@ -2028,7 +2062,7 @@ void regulatory_hint_11d(struct wiphy *wiphy,
> >           wiphy_idx_valid(last_request->wiphy_idx)))
> >               goto out;
> >
> > -     rd = country_ie_2_rd(country_ie, country_ie_len, &checksum);
> > +     rd = country_ie_2_rd(band, country_ie, country_ie_len, &checksum);
> >       if (!rd) {
> >               REG_DBG_PRINT("cfg80211: Ignoring bogus country IE\n");
> >               goto out;
> > diff --git a/net/wireless/reg.h b/net/wireless/reg.h
> > index 3362c7c..3018508 100644
> > --- a/net/wireless/reg.h
> > +++ b/net/wireless/reg.h
> > @@ -41,14 +41,25 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
> >   * regulatory_hint_11d - hints a country IE as a regulatory domain
> >   * @wiphy: the wireless device giving the hint (used only for reporting
> >   *   conflicts)
> > + * @band: the band on which the country IE was received on. This determines
> > + *   the band we'll process the country IE channel triplets for.
> >   * @country_ie: pointer to the country IE
> >   * @country_ie_len: length of the country IE
> >   *
> >   * We will intersect the rd with the what CRDA tells us should apply
> >   * for the alpha2 this country IE belongs to, this prevents APs from
> >   * sending us incorrect or outdated information against a country.
> > + *
> > + * The AP is expected to provide Country IE channel triplets for the
> > + * band it is on. It is technically possible for APs to send channel
> > + * country IE triplets even for channels outside of the band they are
> > + * in but for that they would have to use the regulatory extension
> > + * in combination with a triplet but this behaviour is currently
> > + * not observed. For this reason if a triplet is seen with channel
> > + * information for a band the BSS is not present in it will be ignored.
> >   */
> >  void regulatory_hint_11d(struct wiphy *wiphy,
> > +                      enum ieee80211_band band,
> >                        u8 *country_ie,
> >                        u8 country_ie_len);
> >
> > diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> > index 2333d78..2ce5e16 100644
> > --- a/net/wireless/sme.c
> > +++ b/net/wireless/sme.c
> > @@ -454,6 +454,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
> >        * - and country_ie[1] which is the IE length
> >        */
> >       regulatory_hint_11d(wdev->wiphy,
> > +                         bss->channel->band,
> >                           country_ie + 2,
> >                           country_ie[1]);
> >  }
> >
> 
> I think the channel conversion could be improved (we could directly
> compare the channel number with valid values as defined in
> IEEE802.11-2007 without converting them to a center frequency), but it
> could be done in a latter patch. So far :

Well so channel conversion really needs more work than that
actually, it should eventually address regulatory extension
stuff, which I've been avoiding for long now.

  Luis
