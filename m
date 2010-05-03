Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63640 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab0ECXKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 19:10:30 -0400
Received: by pxi5 with SMTP id 5so500481pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 16:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87och0j7jj.fsf@purkki.valot.fi>
References: <87och0j7jj.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 May 2010 16:10:10 -0700
Message-ID: <w2q43e72e891005031610uf6b912aduf271b0a97933d68a@mail.gmail.com>
Subject: Re: HT rate warning with openwrt AP using wireless-compat and ath9k
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 2:27 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Hi,
>
> I'm running OpenWrt 10.03 on Netgear WNDR3700 and I'm having stability
> issues. The AP reboots few times a week, maybe even daily. I get the
> feeling that my wife's windows laptop is related to the reboots
> somehow, but I haven't investigated this in detail yet. Also I do not
> have access to serial console, so I don't have proper logs.
>
> But today the AP didn't reboot, wireless was just dead. I managed to
> find this with ssh:
>
> ------------[ cut here ]------------
> WARNING: at
> /home/openwrt/backfire/build/ar71xx/build_dir/linux-ar71xx/compat-wireless-2010-03-24/net/mac80211/rx.c:2528
> 0x83115884()
> Rate marked as an HT rate but passed status->rate_idx is not an MCS
> index [0-76]: 123 (0x7b)

This happens when the hardware passes up a frame with an invalid rate.
Instead of discarding them we just set the rate as 1 Mbps as the frame
is already processed and marked as OK but I'm starting to think that
is a mistake and we should just consider dropping them altogether.
This will need some more review.

For now lets review your specific case since it might be that you can
reproduce this. ath9k *should not* be passing up frames with a bad
rate index, in fact ath9k will override the rate to 0, the first rate,
which is 1mbps. In ath9k_process_rate() we have:

static u8 ath9k_process_rate(struct ath_common *common,
                             struct ieee80211_hw *hw,
                             struct ath_rx_status *rx_stats,
                             struct ieee80211_rx_status *rxs,
                             struct sk_buff *skb)
{
        struct ieee80211_supported_band *sband;
        enum ieee80211_band band;
        unsigned int i = 0;

        band = hw->conf.channel->band;
        sband = hw->wiphy->bands[band];

        if (rx_stats->rs_rate & 0x80) {
                /* HT rate */
                rxs->flag |= RX_FLAG_HT;
                if (rx_stats->rs_flags & ATH9K_RX_2040)
                        rxs->flag |= RX_FLAG_40MHZ;
                if (rx_stats->rs_flags & ATH9K_RX_GI)
                        rxs->flag |= RX_FLAG_SHORT_GI;
                return rx_stats->rs_rate & 0x7f;
        }

        for (i = 0; i < sband->n_bitrates; i++) {
                if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
                        return i;
                if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
                        rxs->flag |= RX_FLAG_SHORTPRE;
                        return i;
                }
        }

        /* No valid hardware bitrate found -- we should not get here */
        ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
                  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
        if ((common->debug_mask & ATH_DBG_XMIT))
                print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);

        return 0;
}

Can you enable ATH_DBG_XMIT on the box and see if this comes up?

        ATH_DBG_XMIT            = 0x00000080,

So just modprobe ath9k debug=0x80. I'll send an RFT patch soon.

  Luis
