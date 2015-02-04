Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16352 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbbBDIuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 03:50:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: implement fw stats for wmi-tlv
References: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Feb 2015 10:49:55 +0200
In-Reply-To: <1422611244-20767-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 30 Jan 2015 10:47:20 +0100")
Message-ID: <874mr2uklo.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_095011_843114_C1FD57B6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There are some slight differences in fw stats
> (sic) in wmi-tlv.
>
> Firmware has changed the querying scheme and no
> longer requires the ping-pong to get all stats.
> The patchset doesn't change this behaviour so with
> wmi-tlv it's possible to see the following
> warnings when reading fw stats:
>
>  ath10k_pci 0000:00:06.0: received unsolicited stats update event
>
> The logic in ath10k still produces correct results
> so this is harmless.
>
> I wonder how to deal with this in a sane way. An
> `if (op_ver == WMI_TLV)` is a little bad but
> having a new ar->fw_feature flag just for a debug
> facility like this is a bit silly. Or we can just
> drop the warning and leave a comment. Ideas?

I think we could just remove the warning.

> Michal Kazior (4):
>   ath10k: add vdev stats processing
>   ath10k: change request stats command prototype
>   ath10k: add more wmi fw stat defines
>   ath10k: implement fw stats for wmi-tlv

There was a conflict in patch 2 but 3-way merge solved it automatically.
Please check the result in the pending branch.

-- 
Kalle Valo
