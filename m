Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36211 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbcEWRsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 13:48:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id x130so13231429oia.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2016 10:48:15 -0700 (PDT)
Subject: Re: "kernel: BUG: scheduling while atomic:" errors with linux kernel
 4.6
To: james@nurealm.net, Bob Copeland <me@bobcopeland.com>
References: <e2d89c7d-7567-c3ac-505e-7a9aa887c158@nurealm.net>
 <20160519225612.GB12028@localhost> <573F2FB3.6090206@lwfinger.net>
 <e69117a3-50d4-48bc-d67f-c083e6e3af13@nurealm.net>
Cc: hostap@lists.infradead.org, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5743425D.8020209@lwfinger.net> (sfid-20160523_194821_035524_E12825EF)
Date: Mon, 23 May 2016 12:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <e69117a3-50d4-48bc-d67f-c083e6e3af13@nurealm.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2016 12:29 PM, James Feeney wrote:
> On 05/20/2016 09:39 AM, Larry Finger wrote:
>> @James: Please run the command "dmesg | grep rtl_rfreg_delay". Do any of the
>> resulting lines show a value other than "+0x38" for the offset? If that is the
>> only one, the attached patch should fix the problem.
>
> Sorry about the delayed response.
>
> $ dmesg | grep rtl_rfreg_delay
> [   15.936262]  [<ffffffffa06b1218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
> [  348.735402]  [<ffffffffa06b1218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
>
> So that looks like a no, just the "+0x38" for the offset.

I was able to duplicate the BUG and have submitted a patch. I think you were in 
the Cc list. The patch will appear sometime in the 4.7-rcX series, and will be 
ported to kernel 4.6 once it appears in the mainline repo.

Larry


