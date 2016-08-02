Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:35129 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751640AbcHBG7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 02:59:13 -0400
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	<linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de> (sfid-20160802_085925_531488_6E4E072C)
Date: Tue, 2 Aug 2016 08:53:55 +0200
MIME-Version: 1.0
In-Reply-To: <20160802063419.GG3296@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
> On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
>>> The sysdata API's main goal rather is to provide a flexible API first,
>>> compartamentalizing the usermode helper was secondary. But now it seems
>>> I may just also add devm support too to help simplify code further.
>>
>> I missed the point that you plan to add usermode helper support to
>> the sysdata API.
>
> I had no such plans, when I have asked folks so far about "hey are you
> really in need for it, OK what for? " and "what extended uses do you
> envision?" so I far I have not gotten any replies at all. So -- instead
> sysdata currently ignores it.

So you argue for the remoteproc use case with 100+ MB firmware that if 
there is a way to load after pivot_root() (or other additional firmware 
partition shows up) then there is no need at all for usermode helper?
