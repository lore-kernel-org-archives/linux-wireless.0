Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48052 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaDKGXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 02:23:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
	<87fvllhctr.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkL8Vp_hjOP-=RZL97QXScF+WVX=BGf6d-HY8cQmu=WCQ@mail.gmail.com>
Date: Fri, 11 Apr 2014 09:22:50 +0300
In-Reply-To: <CA+BoTQkL8Vp_hjOP-=RZL97QXScF+WVX=BGf6d-HY8cQmu=WCQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 10 Apr 2014 09:43:13 +0200")
Message-ID: <87r454fkqt.fsf@kamboji.qca.qualcomm.com> (sfid-20140411_082321_168775_BDA1A614)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 April 2014 09:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> The idea is you need BOTH locks to modify the list structure, but you
>>> need only one of them to iterate over the list safely and
>>> consistently. This means writer will not alter the list structure
>>> until there are no readers.
>>
>> Still not understanding this. Why not then use conf_mutex always, why do
>> we need data_lock at all?
>
> htt peer map/unmap which is in tasklet context needs to iterate over
> the list. It can't take conf_mutex.
>
>> Or are you saying that one can iterate the list by either taking
>> conf_mutex or by taking data_lock, depending on context?
>
> Yes.

Thanks, finally I understand this. At least the comment below needs to
be changed to cover all cases:

--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -100,13 +100,13 @@ exit:
 		wake_up(&htt->empty_tx_wq);
 }
 
+/* hold conf_mutex for simple iteration, or conf_mutex+data_lock for
+ * modifications */
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr)
 {
 	struct ath10k_peer *peer;
 
-	lockdep_assert_held(&ar->data_lock);
-
 	list_for_each_entry(peer, &ar->peers, list) {
 		if (peer->vdev_id != vdev_id)
 			continue;

The other thing is that I really like the idea of documenting locking
requirements with lockdep_assert_held() and I hate to lose that in this
function. I started to think should we come up with our own macro for
checking if either of two locks is held? When I look at the original
macro I think it should be pretty easy:

#define lockdep_assert_held(l)	do {				\
		WARN_ON(debug_locks && !lockdep_is_held(l));	\
	} while (0)

-- 
Kalle Valo
