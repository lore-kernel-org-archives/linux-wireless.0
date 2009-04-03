Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:18991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556AbZDCPBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 11:01:37 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1007523fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 08:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238711166-2208-3-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	<1238711166-2208-3-git-send-email-lrodriguez@atheros.com>
Date: Fri, 3 Apr 2009 17:01:18 +0200
Message-ID: <69e28c910904030801k7fb2794bodaea74bb551dbcea@mail.gmail.com> (sfid-20090403_170157_376546_EAAC2582)
Subject: Re: [PATCH 2/5] wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings!

I think that other references to "fat" should be removed as well, in
favor of "HT40".

On Fri, Apr 3, 2009 at 12:26 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This is more consistent with our nl80211 naming convention
> for HT40-/+.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> =A0drivers/net/wireless/iwlwifi/iwl-core.c =A0 | =A0 =A04 ++--
> =A0drivers/net/wireless/iwlwifi/iwl-eeprom.c | =A0 =A08 ++++----
> =A0include/net/wireless.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 12 ++++++------
> =A0net/mac80211/mlme.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =
=A0 =A04 ++--
> =A0net/wireless/reg.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 16 ++++++++--------
> =A05 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wi=
reless/iwlwifi/iwl-core.c
> index c54fb93..d558797 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -591,10 +591,10 @@ static u8 iwl_is_channel_extension(struct iwl_p=
riv *priv,
>
> =A0 =A0 =A0 =A0if (extension_chan_offset =3D=3D IEEE80211_HT_PARAM_CH=
A_SEC_ABOVE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return !(ch_info->fat_extension_channe=
l &

This should be ch_info->ht40_channel or ht40_ext_channel IMO.

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_FAT_ABOVE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_HT40PLUS);
> =A0 =A0 =A0 =A0else if (extension_chan_offset =3D=3D IEEE80211_HT_PAR=
AM_CHA_SEC_BELOW)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return !(ch_info->fat_extension_channe=
l &

Same here.

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_FAT_BELOW);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_HT40MINUS);
>
> =A0 =A0 =A0 =A0return 0;
> =A0}
> diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/=
wireless/iwlwifi/iwl-eeprom.c
> index 75517d0..9d73f19 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
> @@ -481,8 +481,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* First write that fa=
t is not enabled, and then enable

This is especially confusing - "First write that HT40 is disabled"
would be better.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * one by one */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ch_info->fat_extension=
_channel =3D

ch_info->ht40_channel =3D

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (IEEE80=
211_CHAN_NO_FAT_ABOVE |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE=
80211_CHAN_NO_FAT_BELOW);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (IEEE80=
211_CHAN_NO_HT40PLUS |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE=
80211_CHAN_NO_HT40MINUS);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(is_channel_valid=
(ch_info))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IWL_DE=
BUG_INFO(priv, "Ch. %d Flags %x [%sGHz] - "
> @@ -561,7 +561,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fat_ex=
tension_chan =3D 0;

Same here.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fat_ex=
tension_chan =3D

Same here.

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_FAT_BELOW;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IEEE80211_CHAN_NO_HT40MINUS;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Set up driver's inf=
o for lower half */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iwl_set_fat_chan_info(=
priv, ieeeband,

iwl_set_ht40_info would sound a lot better.

> @@ -573,7 +573,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iwl_set_fat_chan_info(=
priv, ieeeband,

Same here.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(eeprom_ch_index[ch] + 4),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0&(eeprom_ch_info[ch]),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 IEEE80211_CHAN_NO_FAT_ABOVE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 IEEE80211_CHAN_NO_HT40PLUS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> diff --git a/include/net/wireless.h b/include/net/wireless.h
> index e3077e1..0331d26 100644
> --- a/include/net/wireless.h
> +++ b/include/net/wireless.h
> @@ -40,21 +40,21 @@ enum ieee80211_band {
> =A0* =A0 =A0 on this channel.
> =A0* @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
> =A0* @IEEE80211_CHAN_RADAR: Radar detection is required on this chann=
el.
> - * @IEEE80211_CHAN_NO_FAT_ABOVE: extension channel above this channe=
l
> + * @IEEE80211_CHAN_NO_HT40PLUS: extension channel above this channel
> =A0* =A0 =A0 is not permitted.
> - * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channe=
l
> + * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channe=
l
> =A0* =A0 =A0 is not permitted.
> =A0* @IEEE80211_CHAN_NO_HT40: indicates no HT40 is allowed at all,
> - * =A0 =A0 when this is set %IEEE80211_CHAN_NO_FAT_ABOVE and
> - * =A0 =A0 %IEEE80211_CHAN_NO_FAT_BELOW will also be set.
> + * =A0 =A0 when this is set %IEEE80211_CHAN_NO_HT40PLUS and
> + * =A0 =A0 %IEEE80211_CHAN_NO_HT40MINUS will also be set.
> =A0*/
> =A0enum ieee80211_channel_flags {
> =A0 =A0 =A0 =A0IEEE80211_CHAN_DISABLED =A0 =A0 =A0 =A0 =3D 1<<0,
> =A0 =A0 =A0 =A0IEEE80211_CHAN_PASSIVE_SCAN =A0 =A0 =3D 1<<1,
> =A0 =A0 =A0 =A0IEEE80211_CHAN_NO_IBSS =A0 =A0 =A0 =A0 =A0=3D 1<<2,
> =A0 =A0 =A0 =A0IEEE80211_CHAN_RADAR =A0 =A0 =A0 =A0 =A0 =A0=3D 1<<3,
> - =A0 =A0 =A0 IEEE80211_CHAN_NO_FAT_ABOVE =A0 =A0 =3D 1<<4,
> - =A0 =A0 =A0 IEEE80211_CHAN_NO_FAT_BELOW =A0 =A0 =3D 1<<5,
> + =A0 =A0 =A0 IEEE80211_CHAN_NO_HT40PLUS =A0 =A0 =A0=3D 1<<4,
> + =A0 =A0 =A0 IEEE80211_CHAN_NO_HT40MINUS =A0 =A0 =3D 1<<5,
> =A0 =A0 =A0 =A0IEEE80211_CHAN_NO_HT40 =A0 =A0 =A0 =A0 =A0=3D 1<<6,
> =A0};
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7ecda9d..3670014 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -263,13 +263,13 @@ static void ieee80211_send_assoc(struct ieee802=
11_sub_if_data *sdata)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (ht_info->ht_param & IEEE80211_=
HT_PARAM_CHA_SEC_OFFSET) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & IEEE80211_C=
HAN_NO_FAT_ABOVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & IEEE80211_C=
HAN_NO_HT40PLUS) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cap &=3D=
 ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cap &=3D=
 ~IEEE80211_HT_CAP_SGI_40;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & IEEE80211_C=
HAN_NO_FAT_BELOW) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & IEEE80211_C=
HAN_NO_HT40MINUS) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cap &=3D=
 ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cap &=3D=
 ~IEEE80211_HT_CAP_SGI_40;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 91f7b34..6f25ef4 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1185,8 +1185,8 @@ static void reg_process_ht_flags_channel(struct=
 wiphy *wiphy,
>
> =A0 =A0 =A0 =A0if (channel->flags &
> =A0 =A0 =A0 =A0 =A0 =A0(IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_H=
T40)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_F=
AT_ABOVE |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IEE=
E80211_CHAN_NO_FAT_BELOW;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_H=
T40PLUS |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IEE=
E80211_CHAN_NO_HT40MINUS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> @@ -1209,15 +1209,15 @@ static void reg_process_ht_flags_channel(stru=
ct wiphy *wiphy,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (!channel_before || (channel_before->flags &
> =A0 =A0 =A0 =A0 =A0 =A0(IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_H=
T40)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_F=
AT_BELOW;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_H=
T40MINUS;
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags &=3D ~IEEE80211_CHAN_NO_=
=46AT_BELOW;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags &=3D ~IEEE80211_CHAN_NO_=
HT40MINUS;
>
> =A0 =A0 =A0 =A0if (!channel_after || (channel_after->flags &
> =A0 =A0 =A0 =A0 =A0 =A0(IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_H=
T40)))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_F=
AT_ABOVE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags |=3D IEEE80211_CHAN_NO_H=
T40PLUS;
> =A0 =A0 =A0 =A0else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags &=3D ~IEEE80211_CHAN_NO_=
=46AT_ABOVE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel->flags &=3D ~IEEE80211_CHAN_NO_=
HT40PLUS;
> =A0}
>
> =A0static void reg_process_ht_flags_band(struct wiphy *wiphy,
> @@ -1299,8 +1299,8 @@ static void handle_channel_custom(struct wiphy =
*wiphy,
>
> =A0 =A0 =A0 =A0if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bw_flags =3D IEEE80211_CHAN_NO_HT40 |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE80211_CHAN_N=
O_FAT_BELOW |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE80211_CHAN_N=
O_FAT_ABOVE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE80211_CHAN_N=
O_HT40MINUS |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IEEE80211_CHAN_N=
O_HT40PLUS;
>
> =A0 =A0 =A0 =A0chan->flags |=3D map_regdom_flags(reg_rule->flags) | b=
w_flags;
> =A0 =A0 =A0 =A0chan->max_antenna_gain =3D (int) MBI_TO_DBI(power_rule=
->max_antenna_gain);
> --
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I'll possibly submit a patch for this tomorrow (though I haven't
booted my Linux install for like a month, and it is still @
2.6.28-wl).

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
