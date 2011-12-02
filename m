Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3776 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab1LBLxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 06:53:01 -0500
Message-ID: <4ED8BC17.9080906@qca.qualcomm.com> (sfid-20111202_125306_508880_8960DB6A)
Date: Fri, 2 Dec 2011 13:52:55 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Inform bss information to cfg80211 before connect
 event
References: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com> <20111202114843.GC4358@jouni.qca.qualcomm.com>
In-Reply-To: <20111202114843.GC4358@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2011 01:48 PM, Jouni Malinen wrote:
> On Fri, Dec 02, 2011 at 03:06:59PM +0530, Vasanthakumar Thiagarajan wrote:
>> This is already done but only when bss entry is not availabe
>> or aged out. Not updating the bss information when that bss
>> is available creates a case where there is a bss entry when
>> checked in ath6kl_cfg80211_connect_event() but it got aged out
>> by the time cfg80211 checks for the bss entry in __cfg80211_roamed().
>> This results in the following warning and the failure to notify
>> roaming event to application. To fix this, update the bss information
>> for which a romaing event is received. Also renamed ath6kl_add_bss_if_needed()
>> to ath6kl_inform_bss().
> 
> I don't think this is a good fix for the problem and would prefer this
> not getting applied before the real issue is fully understood.

I have already dropped this per Vasanth's request and will wait for v2.

Kalle
