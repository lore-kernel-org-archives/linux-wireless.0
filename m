Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35474 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbGAQuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 12:50:24 -0400
Received: by wgjx7 with SMTP id x7so41889943wgj.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2015 09:50:23 -0700 (PDT)
Subject: Re: [PATCH 3/3] staging: rtl8723au: function no longer discards
 return value
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
 <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com>
 <20150701071224.GC2411@sudip-PC> <20150701075042.GT28762@mwanda>
 <20150701080827.GE2411@sudip-PC>
Cc: devel@driverdev.osuosl.org, gregkh@linux.com,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jes.Sorensen@redhat.com
From: Michel von Czettritz <michel.von.czettritz@gmail.com>
Message-ID: <55941A4B.3060406@gmail.com> (sfid-20150701_185027_882070_C2C84242)
Date: Wed, 1 Jul 2015 18:50:19 +0200
MIME-Version: 1.0
In-Reply-To: <20150701080827.GE2411@sudip-PC>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2015 10:08 AM, Sudip Mukherjee wrote:
> On Wed, Jul 01, 2015 at 10:50:42AM +0300, Dan Carpenter wrote:
>> On Wed, Jul 01, 2015 at 12:42:24PM +0530, Sudip Mukherjee wrote:
>>> On Tue, Jun 30, 2015 at 11:54:59PM +0200, Michel von Czettritz wrote:
>>>> The return value of FillH2CCmd in rtl8723a_set_rssi_cmd and
>>>> rtl8723a_set_raid_cmd is never checked. Both functions always return
>>>> _SUCCESS.
>>>>
>>>> Both functions now return the return value of FillH2CCmd.
>>> If they are never checked then why do we need to return some value?
>>> why not make them void?
>>
>> They probably *should* be checked eventually?
> yes, they should check the sucess/failure of the commands. If that plan
> is there to check the values afterwards then the patch is correct.
Both functions are currently only called by void functions, which don't check on the return values of the functions. 
Nonetheless I think rtl8723a_set_rssi_cmd and rtl8723a_set_raid_cmd should return correct values and another patch should take on the calling void functions error handling.
As I'm not fully familiar with the inner workings of the driver, I'd leave the error handling for somebody else to implement, or would take it on later.

regards Michel

