Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34189 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbcBOJQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 04:16:53 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Peller, EliadX" <eliadx.peller@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: mvm: move TX PN assignment for TKIP to the
 driver
Date: Mon, 15 Feb 2016 09:16:48 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA1331F@hasmsx107.ger.corp.intel.com> (sfid-20160215_101658_410444_68FEAC15)
References: <1455450997-15409-1-git-send-email-emmanuel.grumbach@intel.com>
 <1455450997-15409-2-git-send-email-emmanuel.grumbach@intel.com>
 <CANUX_P3Ybzowsf3Kg7TFhtpq+H4bDWMswrGHhkrvHKtnZaEVhA@mail.gmail.com>
 <1455477875.2564.0.camel@sipsolutions.net>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA122F3@hasmsx107.ger.corp.intel.com>
 <CAB3XZEdXC1jG5FXOPu-seT2pVzKa6Sg15s_YTeMnULi7vBgL5A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/15/2016 11:06 AM, Eliad Peller wrote:
> On Sun, Feb 14, 2016 at 9:37 PM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>>
>> On 02/14/2016 09:33 PM, Johannes Berg wrote:
>>> On Sun, 2016-02-14 at 19:34 +0200, Emmanuel Grumbach wrote:
>>>> Since the 3rd patch needs to be dropped anyway, let's route this one
>>>> through my tree as usual.
>>> It doesn't really have to be dropped, why? We can just make the same
>>> adjustment as for dvm in the patch.
>>>
>> But I am not sure I really want to play with drivers/staging/vt6656/rxtx.c
> here you go:
>
> diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
> index b668db6..1a2dda0 100644
> --- a/drivers/staging/vt6655/rxtx.c
> +++ b/drivers/staging/vt6655/rxtx.c
> @@ -1210,7 +1210,7 @@ static void vnt_fill_txkey(struct ieee80211_hdr
> *hdr, u8 *key_buffer,
>     struct sk_buff *skb, u16 payload_len,
>     struct vnt_mic_hdr *mic_hdr)
>  {
> - struct ieee80211_key_seq seq;
> + u64 pn64;
>   u8 *iv = ((u8 *)hdr + ieee80211_get_hdrlen_from_skb(skb));
>
>   /* strip header and icv len from payload */
> @@ -1243,9 +1243,13 @@ static void vnt_fill_txkey(struct ieee80211_hdr
> *hdr, u8 *key_buffer,
>   mic_hdr->payload_len = cpu_to_be16(payload_len);
>   ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
>
> - ieee80211_get_key_tx_seq(tx_key, &seq);
> -
> - memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
> + pn64 = atomic64_read(&tx_key->tx_pn);
> + mic_hdr->ccmp_pn[5] = pn64;
> + mic_hdr->ccmp_pn[4] = pn64 >> 8;
> + mic_hdr->ccmp_pn[3] = pn64 >> 16;
> + mic_hdr->ccmp_pn[2] = pn64 >> 24;
> + mic_hdr->ccmp_pn[1] = pn64 >> 32;
> + mic_hdr->ccmp_pn[0] = pn64 >> 40;
>
>   if (ieee80211_has_a4(hdr->frame_control))
>   mic_hdr->hlen = cpu_to_be16(28);
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index efb54f5..76378d2 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -719,7 +719,7 @@ static void vnt_fill_txkey(struct
> vnt_usb_send_context *tx_context,
>   u16 payload_len, struct vnt_mic_hdr *mic_hdr)
>  {
>   struct ieee80211_hdr *hdr = tx_context->hdr;
> - struct ieee80211_key_seq seq;
> + u64 pn64;
>   u8 *iv = ((u8 *)hdr + ieee80211_get_hdrlen_from_skb(skb));
>
>   /* strip header and icv len from payload */
> @@ -752,9 +752,13 @@ static void vnt_fill_txkey(struct
> vnt_usb_send_context *tx_context,
>   mic_hdr->payload_len = cpu_to_be16(payload_len);
>   ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
>
> - ieee80211_get_key_tx_seq(tx_key, &seq);
> -
> - memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
> + pn64 = atomic64_read(&tx_key->tx_pn);
> + mic_hdr->ccmp_pn[5] = pn64;
> + mic_hdr->ccmp_pn[4] = pn64 >> 8;
> + mic_hdr->ccmp_pn[3] = pn64 >> 16;
> + mic_hdr->ccmp_pn[2] = pn64 >> 24;
> + mic_hdr->ccmp_pn[1] = pn64 >> 32;
> + mic_hdr->ccmp_pn[0] = pn64 >> 40;
>
>   if (ieee80211_has_a4(hdr->frame_control))
>   mic_hdr->hlen = cpu_to_be16(28);
>
>
> Eliad.
>

Want to send that patch to Greg? :)
