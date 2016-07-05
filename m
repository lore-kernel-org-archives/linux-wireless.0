Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45782
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbcGENOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 09:14:11 -0400
Subject: Re: [PATCH] mwifiex: fix unconditional error return in
 .add_virtual_intf callback
To: Kalle Valo <kvalo@codeaurora.org>
References: <1467401982-18943-1-git-send-email-javier@osg.samsung.com>
 <87twg42pvd.fsf@kamboji.qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <d5ce9992-6a1e-b5f1-2edb-bc1096cc15df@osg.samsung.com> (sfid-20160705_151916_343472_7BFC36D5)
Date: Tue, 5 Jul 2016 09:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <87twg42pvd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

On 07/05/2016 09:09 AM, Kalle Valo wrote:
> Javier Martinez Canillas <javier@osg.samsung.com> writes:
> 
>> The commit 7311ea850079 ("mwifiex: fix AP start problem for newly added
>> interface") attempted to fix an issue when a new AP interface is added.
>>
>> But the patch didn't check the return value of the functions doing the
>> firmware calls and returned an error even if the functions didn't fail.
>>
>> This prevents the network device to be registered properly, so fix it.
>>
>> Fixes: commit 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The fixes line should be:
> 
> Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
> 
> I can fix that before I apply the patch.
> 

Sigh, it was a copy and paste error when I copied the SHA-1 from the
commit message. Sorry about that and thanks for taking care of this.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
