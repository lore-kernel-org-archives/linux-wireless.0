Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50286 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1IVHfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:35:15 -0400
Received: by eya28 with SMTP id 28so1421028eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316606713.3940.29.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-3-git-send-email-arik@wizery.com> <1316606713.3940.29.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 10:34:58 +0300
Message-ID: <CA+XVXffOFw9RFFuwDTB_ei6Ktwai1tCicTuTeF5=4=WqZSZafw@mail.gmail.com> (sfid-20110922_093519_902674_187DAE26)
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
To: Johannes Berg <johannes@sipsolutions.net>,
	Kalyan C Gaddam <chakkal@iit.edu>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 15:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>
>> +static void ieee80211_tdls_add_supp_rates(struct ieee80211_sub_if_data *sdata,
>> +                                       struct sk_buff *skb)
>
> maybe it's time to refactor adding supported rates? This must be like
> the 5th implementation of it ... mesh has exactly the same at least.

They're not all exactly the same, but yeah, mesh has exactly the same
one (with no basic rates).
I'll move it to util.c and have both places use it.

>> +     *pos++ = 0x20; /* TDLS enabled */
>
> That might benefit from a constant in ieee80211.h

Will do.

>
>> +static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     u16 capab;
>> +     struct ieee80211_local *local = sdata->local;
>> +
>> +     /* We do not support any exotic capabilities yet */
>> +
>> +     capab = WLAN_CAPABILITY_ESS;
>
> Should we really set the ESS bit for TDLS?

Well I saw this bit set in an example tdls pcap that Jouni provided
the wireshark list a while ago. I haven't seen anything about it in
the spec, but I assumed there was some inter-op cause for this.
This was on in Kalyan's original patches as well.

Kalyan, Jouni - care to comment?

>> +     lnkid->ie_len = 18;
>
> sizeof too?

Sure.

>
>> +     memcpy(tf->da, peer, ETH_ALEN);
>> +     memcpy(tf->sa, sdata->vif.addr, ETH_ALEN);
>> +     tf->ether_type = cpu_to_be16(ETH_P_TDLS);
>> +     tf->payload_type = 2; /* RFTYPE_TDLS */
>
> another constant?

Right.

>
>> +     default:
>> +             /* we don't support other actions for now */
>> +             WARN_ON(1);
>> +             return -EINVAL;
>
> Wouldn't that warning be triggerable from userspace?

That was more of a debugging thing. I guess I should remove these.

>
>> +static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
>> +                            u8 *peer, u8 action_code, u8 dialog_token,
>> +                            u16 status_code, const u8 *extra_ies,
>> +                            size_t extra_ies_len)
>> +{
>> +     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +     struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_tx_info *info;
>> +     struct sk_buff *skb = NULL;
>> +     bool send_direct;
>> +     int ret;
>> +
>> +#ifdef CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
>> +     printk(KERN_DEBUG "TDLS mgmt action %d peer %pM\n", action_code, peer);
>> +#endif
>> +
>> +     /* make sure we are in managed mode, and associated */
>> +     if (sdata->vif.type != NL80211_IFTYPE_STATION ||
>> +         !sdata->u.mgd.associated) {
>> +             return -EINVAL;
>> +     }
>
> braces here seem useless :)

Will fix.

>
> Also accessing u.mgd.associated as a bool like this is fine, but
> obviously racy. How do we deal with that? Do we even tear down links
> when disassociating, and do we even need to beyond just killing the
> station entries?

We don't tear down links just before disassociating (there are too
many corner cases here). We just disable the links post-factum.
Killing the station entries won't help for packets meant to be sent
over the AP. I guess we can take the mutex for a little extra safely
(but it won't do much).

The race is even worse - from queuing until the actual Tx, we could
have disconnected from this AP and connected do a totally different
one. But this shouldn't happen in reality (and we can add some guards
to wpa_supplicant to make sure).
Do you see this as a security threat?

>
>> +     skb = dev_alloc_skb(local->hw.extra_tx_headroom +
>> +                         max(sizeof(struct ieee80211_mgmt),
>> +                             sizeof(struct ieee80211_tdls_data)) +
>> +                         50 + /* supported rates */
>> +                         7 + /* ext capab */
>> +                         sizeof(struct ieee80211_tdls_lnkie));
>
> Where are the extra IEs used? They should be accounted for too.

Good catch.

>
>> +fail:
>> +     if (skb)
>> +             dev_kfree_skb(skb);
>
> I believe the if() is pointless.

ok.

>
>> +     case NL80211_TDLS_DISABLE_LINK:
>> +             rcu_read_lock();
>> +             sta = sta_info_get(sdata, peer);
>> +             if (sta) {
>> +                     sta->tdls_link_enabled = false;
>> +                     sta_info_destroy_addr(sdata, peer);
>> +             }
>> +             rcu_read_unlock();
>
> You can't call destroy_addr within rcu section.

Another good catch.

>
>> +     case NL80211_TDLS_TEARDOWN:
>> +     case NL80211_TDLS_SETUP:
>> +     case NL80211_TDLS_DISCOVERY_REQ:
>> +             /* We don't support in-driver setup/teardown/discovery */
>> +             return -ENOTSUPP;
>> +     case NL80211_TDLS_DISABLE:
>> +     case NL80211_TDLS_ENABLE:
>> +             /* TODO */
>> +             return -ENOTSUPP;
>> +     default:
>> +             WARN_ON(1);
>> +             return -EINVAL;
>
> might want to use EOPNOTSUPP and not have a warning -- if nl80211 ever
> gets extended with more actions you might run into the default case.

Yea I'll remove this one as well as a couple more.

Arik
