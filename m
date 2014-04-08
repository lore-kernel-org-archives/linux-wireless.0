Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaDHHEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 03:04:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: refactor radar detection code
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-3-git-send-email-michal.kazior@tieto.com>
	<87bnwdnslk.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=-vrJ_tize+uwCp5jgM7pvPZ0s9bGUK42Ko1TCHzmfzg@mail.gmail.com>
Date: Tue, 8 Apr 2014 10:04:05 +0300
In-Reply-To: <CA+BoTQ=-vrJ_tize+uwCp5jgM7pvPZ0s9bGUK42Ko1TCHzmfzg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 8 Apr 2014 08:32:58 +0200")
Message-ID: <87fvlomhei.fsf@kamboji.qca.qualcomm.com> (sfid-20140408_090417_212596_8A57C568)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> Even though this is correct, I think it's still a bit evil. For example,
>> I missed '!' the first time I looked at this. Even this is a line
>> longer, I think it would be easier to read:
>>
>> WARN_ON(ar->num_started_vdevs == 0);
>>
>> if (ar->num_started_vdevs != 0) {
>>         ...
>> }
>
> Sound reasonably.

I changed it like this now:

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -878,7 +878,9 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
                return ret;
        }
 
-       if (!WARN_ON(ar->num_started_vdevs == 0)) {
+       WARN_ON(ar->num_started_vdevs == 0);
+
+       if (ar->num_started_vdevs != 0) {
                ar->num_started_vdevs--;
                ath10k_recalc_radar_detection(ar);

Full patch here:

https://github.com/kvalo/ath/commit/0d57ff8b99539895c5a3714d7ecd80a58b6a8928

-- 
Kalle Valo
