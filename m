Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45431 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1KGVSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:18:11 -0500
Message-ID: <4EB84B0B.601@qca.qualcomm.com> (sfid-20111107_221815_215264_1BE4CAE0)
Date: Mon, 7 Nov 2011 23:18:03 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix error in writing create_qos debugfs
References: <1320411895-4828-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1320411895-4828-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 03:04 PM, Vasanthakumar Thiagarajan wrote:
> 100 bytes are allocated to store the parameters which are needed
> to create a priority stream. These 100 bytes are not sufficiant and
> throws error when running the following command.
> 
> echo "6 2 3 1 1 9999999 9999999 9999999 7777777 0 6 45000 200 56789000
>  56789000 5678900 0 0 9999999 20000 0" > create_qos
> 
> 179 bytes are needed when the following vlaues are given so that
> a maximum possible value in that data type can be given in decimal.
> 
> echo "255 255 255 255 255 4294967295 4294967295 4294967295 4294967295
>  4294967295 255 65535 65535 4294967295 4294967295 4294967295 4294967295
>  4294967295 4294967295 4294967295 4294967295" > create_qos
> 
> Following takes 187 bytes when given in hex
> 
> echo "0xff 0xff 0xff 0xff 0xff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff
>  0xff 0xffff 0xffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff 0xffffffff
>  0xffffffff 0xffffffff" > create_qos
> 
> Increase the size to 200 bytes so that it can hold upto the maximum
> value possible for that data type.

Thanks, applied.

Kalle
