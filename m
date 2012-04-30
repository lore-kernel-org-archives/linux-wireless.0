Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43755 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab2D3UNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 16:13:19 -0400
Received: by wibhj6 with SMTP id hj6so3159672wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 13:13:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3HvPa_ff-km97m+xqwL_wOtbmPtoMk25HXXCYfvYoKzA@mail.gmail.com>
References: <20120422182928.GA2854@ritirata.org>
	<20120430145803.GE2630@ritirata.org>
	<20120430170337.GA2560@tuxdriver.com>
	<CANUX_P3HvPa_ff-km97m+xqwL_wOtbmPtoMk25HXXCYfvYoKzA@mail.gmail.com>
Date: Mon, 30 Apr 2012 23:13:17 +0300
Message-ID: <CANUX_P2j3uqzmQvctNbFaW31NLiVpyapkYaVy3Gpz46+a72LhA@mail.gmail.com> (sfid-20120430_221321_546745_44D8565E)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Antonio Quartulli <ordex@autistici.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> > Hello,
>>> >
>>> > since linux-3.0 (I don't remember if it was the case even before), I'm getting
>>> > this output in dmesg:
>>> >
>>> > [   53.662990] ------------[ cut here ]------------
>>> > [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
>>> > intel_unmap_page+0x14b/0x180()
>>> > [   53.663047] Hardware name: Latitude E5420
>>> > [   53.663066] Driver unmaps unmatched page at PFN ffd1a000
>>>
>>>
>>> I see that I always get the same addr passed to the unmap function:
>>>
>>> [   23.950535] Driver unmaps unmatched page at PFN ffd1a000
>>>
>>> is it a coincidence?
>>> I'm running linux-3.3.3 right now. I can try wireless-testing if it would help.
>>
>> Just for the record, we are seeing a similar problem on RHEL 6.3
>> (which has an iwlwifi driver derived from linux-3.2).
>>
>>        https://bugzilla.redhat.com/show_bug.cgi?id=815998
>>
>
> John I want to hope that this bugzilla would be solved by Johannes
> rework of the locks:
>
> 08ae86ac3f9d9c9a60d2883c82cd72a5c66b94db in wireless-next.
> There are a few patches that completely rewrite the locking model of the driver.

Especially this one:

7b11488fbbbe06ada39a396dec16532db8c933e6
