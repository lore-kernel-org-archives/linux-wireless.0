Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33043 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0JLTvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 15:51:43 -0400
Message-ID: <4CB4BC47.7000907@candelatech.com>
Date: Tue, 12 Oct 2010 12:51:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com> <4CB4AC61.207@candelatech.com>
In-Reply-To: <4CB4AC61.207@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2010 11:43 AM, Ben Greear wrote:
> On 10/12/2010 11:40 AM, Luis R. Rodriguez wrote:
>> On Tue, Oct 12, 2010 at 11:35 AM, Ben Greear<greearb@candelatech.com>
>> wrote:

>>> This code looks weird to me. One of the paprd branches
>>> deletes the skb, the other doesn't appear to. Neither
>>> null out bf->bf_mpdu, which would appear to leave a dangling
>>> pointer in at least the dev_kfree_skb_any() branch.
>>>
>>> ath_tx_complete frees it's skb in all cases, so another
>>> bf->bf_mpdu dangling pointer issue.
>>>
>>> Maybe at the least we should null out bf->bf_mpdu when
>>> skb is consumed?
>>
>> You're reading my mind, that was what I was going to test today. Still
>> doing e-mail sweep though.
>
> I'm trying to put together a patch now..but the paprd branch makes
> no sense at all.
>
> Shouldn't it also free the skb in the complete(&sc->paprd_complete) branch?
> I don't see anything that uses the skb, and nothing that frees it.
>
> if (bf->bf_state.bfs_paprd) {
> if (time_after(jiffies,
> bf->bf_state.bfs_paprd_timestamp +
> msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
> dev_kfree_skb_any(skb);
> else
> complete(&sc->paprd_complete);

I tried this patch, but the memory poision warnings continue.
Might still be a useful patch though...

[greearb@build-32 mac80211]$ git diff
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8656491..f43a004 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -398,7 +398,7 @@ void ath_paprd_calibrate(struct work_struct *work)
                                   "Timeout waiting for paprd training on "
                                   "TX chain %d\n",
                                   chain);
-                       goto fail_paprd;
+                       break;
                 }

                 if (!ar9003_paprd_is_done(ah))
@@ -416,7 +416,6 @@ void ath_paprd_calibrate(struct work_struct *work)
                 ath_paprd_activate(sc);
         }

-fail_paprd:
         ath9k_ps_restore(sc);
  }

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 942be55..d39b4b5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1919,17 +1919,17 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
         dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);

         if (bf->bf_state.bfs_paprd) {
-               if (time_after(jiffies,
-                              bf->bf_state.bfs_paprd_timestamp +
-                              msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
-                       dev_kfree_skb_any(skb);
-               else
-                       complete(&sc->paprd_complete);
+               /* ath_paprd_calibrate owns the skb. */
+               complete(&sc->paprd_complete);
         } else {
-               ath_tx_complete(sc, skb, bf->aphy, tx_flags);
+               /* stat_tx must be called first, it references skb. */
                 ath_debug_stat_tx(sc, txq, bf, ts);
+               ath_tx_complete(sc, skb, bf->aphy, tx_flags);
         }

+       /* At this point, skb is consumed one way or another */
+       bf->bf_mpdu = NULL;
+
         /*
          * Return the list of ath_buf of this mpdu to free queue
          */


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

