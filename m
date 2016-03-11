Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15369 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcCKMUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:20:39 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Steve deRosier <derosier@gmail.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Steve deRosier" <steve.derosier@lairdtech.com>
Subject: Re: [PATCH] ath6kl: ignore WMI_TXE_NOTIFY_EVENTID based on fw
 capability flags
Date: Fri, 11 Mar 2016 12:20:27 +0000
Message-ID: <87r3fhmcj9.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_132043_961983_F2206221)
References: <1457398730-31088-1-git-send-email-steve.derosier@lairdtech.com>
In-Reply-To: <1457398730-31088-1-git-send-email-steve.derosier@lairdtech.com>
	(Steve deRosier's message of "Mon, 7 Mar 2016 16:58:50 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> Certain 6004 firmware releases redefine the WMI_TXE_NOTIFY_EVENTID event
> number and sends the new event frequently. However it doesn't have the
> tx-err-notify feature and thus this firmware capability flag isn't set on
> the firmware package. By guarding the processing of this event by the same
> method we guard the sending of the WMI_SET_TXE_NOTIFY_CMDID command, we
> can ignore the spurious event that we don't know how to process.
>
> Without this change we call cfg80211_cqm_txe_notify() with possibly bad
> data.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

Applied to ath.git, thanks.

-- 
Kalle Valo