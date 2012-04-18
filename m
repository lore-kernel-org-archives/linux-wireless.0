Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1759 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2DRQfh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 12:35:37 -0400
Message-ID: <4F8EED47.3060109@broadcom.com> (sfid-20120418_183541_253115_87D3975E)
Date: Wed, 18 Apr 2012 18:35:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmsmac hangs machine if loaded after busmastering
 disabled
References: <20120319215154.GA18508@srcf.ucam.org>
 <4F856EE9.2040407@broadcom.com> <20120411115118.GA3791@srcf.ucam.org>
 <4F8EA657.7020006@broadcom.com> <20120418123449.GB26953@srcf.ucam.org>
 <4F8EDDE6.9080802@broadcom.com> <20120418153728.GA32224@srcf.ucam.org>
In-Reply-To: <20120418153728.GA32224@srcf.ucam.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 05:37 PM, Matthew Garrett wrote:
> On Wed, Apr 18, 2012 at 05:29:42PM +0200, Arend van Spriel wrote:
>
>> I am not sure, but D3 is a good guess. It is all a workaround as the
>> real fix should be in Apple's UEFI implementation. I think it is
>> unlikely we can make them do that although we probably supplied them
>> the wireless part.
>
> Disabling busmastering and then D3ing the device once in the kernel
> didn't seem to work, but putting the device in D3 while in the firmware
> (and leaving busmastering enabled) seems to avoid the problem.
>

Yup, the master disable itself hangs the device. The device should be 
able to deal with going to D3 so you could try just doing that from the 
kernel.

Gr. AvS


