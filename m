Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab1JQQht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 12:37:49 -0400
Message-ID: <4E9C59D2.1010407@qca.qualcomm.com> (sfid-20111017_183759_333884_4D023B5E)
Date: Mon, 17 Oct 2011 19:37:38 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Implement support for QOS-enable and QOS-disable
 from userspace
References: <1318639687-28457-1-git-send-email-rpanjwan@qca.qualcomm.com> <1318639687-28457-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1318639687-28457-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2011 03:48 AM, Rishi Panjwani wrote:
> In order to allow user space based QOS control we use the available debugfs
> infrastructure. With this feature, user can make changes to qos parameters,
> thereby allowing creation and deletion of user defined priority streams and
> features like uapsd. This feature has been added for testing purposes.
> 
> All 21 parameters for the create_qos command are mandatory in the correct
> order. They have to be written to the create_qos file in
> the ath6kl debug directory. These parameters(in order) are:
> 1)user priority
> 2)direction
> 3)traffic class
> 4)traffic type
> 5)voice PS capability
> 6)min service intvl
> 7)max service intvl
> 8)inactivity intvl
> 9)suspension intvl
> 10)serv start time
> 11)tsid
> 12)nominal msdu
> 13)max msdu
> 14)min data rate
> 15)mean data rate
> 16)peak data rate
> 17)max burst size
> 18)delay bound
> 19)min phy rate
> 20)surplus bw allowance
> 21)medium time
> For eg :
> echo "6 2 3 1 1 9999999 9999999 9999999 7777777 0 6 45000 200 56789000
> 56789000 5678900 0 0 9999999 20000 0" > create_qos
> 
> delete_qos requires 2 parameters:
> 1)traffic class
> 2)tsid
> For eg :
> echo "3 1" > delete_qos

Thanks, applied.

I did minor whitespace changes to the commit log and removed two extra
newlines from the patch.

Kalle
