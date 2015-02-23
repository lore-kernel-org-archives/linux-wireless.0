Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:40731 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbBWSAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 13:00:34 -0500
Received: by labgd6 with SMTP id gd6so20070189lab.7
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 10:00:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150223171700.GA29730@w1.fi>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
Date: Mon, 23 Feb 2015 20:00:32 +0200
Message-ID: <CANUX_P2_0YAz7+7XuM8ZFd_xCTgbUDw0pZ_v7DZT7Ga=ZHDwBw@mail.gmail.com> (sfid-20150223_190038_122440_09EBAB37)
Subject: Re: AR9462 problems connecting again..
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 7:17 PM, Jouni Malinen <j@w1.fi> wrote:
> On Sun, Feb 22, 2015 at 05:41:25PM -0800, Linus Torvalds wrote:
>> Nope, everything else I have seems to be intel wireless. I think one
>> of the kids machines is a Mac Mini with an ath5k thing, but I'm hoping
>> the wpa_supplicant.log is sufficient to give somebody an idea.
>
> It looks like there are two issues here: 1) EAPOL-Key message 4/4 (i.e.,
> the second Data frame sent by the station during association) is somehow
> not seen or accepted by the AP, 2) recovery from that msg 4/4 getting
> lost does not work in the intended way.
>
> For (1), one would likely need to see a wireless capture from a separate
> WLAN radio to say something certain about what exactly happened.
> ath5k-compatible radios would not be sufficient since this would need to
> be able to see HT frames which ath9k is mostly like using here. I
> haven't used iwlwifi as a sniffer, so I do not know whether that would
> be a workable option for this.

iwlwifi as a sniffer is good enough for that.

>
> In my tests, I can see the rate control algorithm (minstrel_ht) using a
> pretty high rate (even MCS14 with 2-stream device, which is one short of
> maximum) which is quite a bit higher than I would myself have selected
> for an EAPOL frame (especially for EAPOL-Key 4/4 which has these lovely
> issues with retransmissions) more or less immediately after association.
> Anyway, that frame is supposed to get additional fall-back TX rates for
> link layer retransmissions and those should make it much more likely for
> this to be received by the AP. Sniffer trace would confirm that.
>

IIRC we had lots of issues with that and iwlwifi's rate control doesn't jump to
high rates immediately.

>
> For (2), wpa_supplicant debug log gives a pretty clear idea on what is
> happening and based on that, I can easily reproduce this part. In fact,
> I now have a fully automated test script for verifying this with
> mac80211_hwsim.
>
> Some alternative means of improving this was discussed in this thread.
> I'm not completely happy with this, but the following mac80211 changes
> do fix this retransmission case and will likely make the issue you are
> seeing disappear since it allows any of the four EAPOL-Key msg 4/4
> transmissions to be received by the AP to avoid the disconnection. This
> doesn't fix the initial trigger behind the issue, but with those EAPOL
> retransmissions working, the likelihood of all four attempts failing
> (with each getting multiple link-layer retransmissions) is quite small.
>
>
> mac80211: Do not encrypt EAPOL frames before peer has used the key
>
> The 4-way handshake design is a bit inconvenient for the case where msg
> 3/4 needs to be transmitted (e.g., AP not receiving first transmission

needs to *re*transmitted I guess.

> of 4/4). The supplicant side has already configured the pairwise key at
> that point in time and while we allow unencrypted msg 3/4 to be
> received, we were sending out 4/4 encrypted which will result in it
> getting dropped. User space would be aware of when the EAPOL frame
> should not be encrypted, but we do not have convenient means of telling
> mac80211 that. For now, use a mac80211-specific hack to avoid EAPOL
> frame encryption to allow retransmission of 4-way handshake messages 3/4
> and 4/4 to work in a way that the authenticator side can process 4/4.
>
> ---
>  net/mac80211/key.h |  2 ++
>  net/mac80211/rx.c  | 11 +++++++++++
>  net/mac80211/tx.c  | 13 +++++++++++++
>  3 files changed, 26 insertions(+)
>
> diff --git a/net/mac80211/key.h b/net/mac80211/key.h
> index d57a9915..3e23276 100644
> --- a/net/mac80211/key.h
> +++ b/net/mac80211/key.h
> @@ -120,6 +120,8 @@ struct ieee80211_key {
>
>         /* number of times this key has been used */
>         int tx_rx_count;
> +       /* whether a valid RX decryption has happened with this key */
> +       bool valid_rx_seen;
>
>  #ifdef CONFIG_MAC80211_DEBUGFS
>         struct {
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 1101563..8f3f86c 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1691,6 +1691,16 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
>         return result;
>  }
>
> +static ieee80211_rx_result debug_noinline
> +ieee80211_rx_h_check_key_use(struct ieee80211_rx_data *rx)
> +{
> +       struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
> +
> +       if ((status->flag & RX_FLAG_DECRYPTED) && rx->key)
> +               rx->key->valid_rx_seen = true;
> +       return RX_CONTINUE;
> +}
> +
>  static inline struct ieee80211_fragment_entry *
>  ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
>                          unsigned int frag, unsigned int seq, int rx_queue,
> @@ -3139,6 +3149,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
>                 CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
>                 CALL_RXH(ieee80211_rx_h_sta_process)
>                 CALL_RXH(ieee80211_rx_h_decrypt)
> +               CALL_RXH(ieee80211_rx_h_check_key_use)
>                 CALL_RXH(ieee80211_rx_h_defragment)
>                 CALL_RXH(ieee80211_rx_h_michael_mic_verify)
>                 /* must be after MMIC verify so header is counted in MPDU mic */
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 88a18ff..c314c59 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -612,6 +612,19 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
>                 return TX_DROP;
>         }
>
> +       if (tx->key &&
> +           unlikely(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO) &&
> +           !tx->key->valid_rx_seen) {
> +               /* Do not encrypt EAPOL frames before peer has used the key */
> +               /* FIX: This is not really complete.. It would be at least
> +                * theoretically possible for the peer to never send a Data
> +                * frame and if we were to initiate reauthentication or
> +                * rekeying, we might need to encrypt the initiating EAPOL
> +                * frame.
> +                */
> +               tx->key = NULL;
> +       }
> +
>         if (tx->key) {
>                 bool skip_hw = false;
>
> --
> Jouni Malinen                                            PGP id EFC895FA
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
