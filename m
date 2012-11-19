Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2886 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2KSVTz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:19:55 -0500
Message-ID: <50AAA275.5030609@broadcom.com> (sfid-20121119_221958_985467_DEFEDFFC)
Date: Mon, 19 Nov 2012 22:19:49 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 09/22] brcm80211: Allow trace support to be
 enabled separately from debug
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-10-git-send-email-seth.forshee@canonical.com>
 <50AA9789.9070807@broadcom.com> <20121119211511.GB20301@thinkpad-t410>
In-Reply-To: <20121119211511.GB20301@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2012 10:15 PM, Seth Forshee wrote:
> On Mon, Nov 19, 2012 at 09:33:13PM +0100, Arend van Spriel wrote:
>> On 11/15/2012 03:07 PM, Seth Forshee wrote:
>>> Since the runtime overhead of trace support is small when tracing is
>>> disabled, users may be interested in turning on trace support while
>>> leaving other debug features off. Add a new config option named
>>> CONFIG_BRCM_TRACING for this purpose.
>>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Arend van Spriel
>>> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>>> ---
>>>   drivers/net/wireless/brcm80211/Kconfig             |   11 +++++++++++
>>>   .../brcm80211/brcmsmac/brcms_trace_events.h        |    6 +++---
>>>   2 files changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
>>> index c9d811e..3735c27 100644
>>> --- a/drivers/net/wireless/brcm80211/Kconfig
>>> +++ b/drivers/net/wireless/brcm80211/Kconfig
>>> @@ -63,6 +63,17 @@ config BRCMISCAN
>>>   	  new E-Scan method which uses less memory in firmware and gives no
>>>   	  limitation on the number of scan results.
>>>
>>> +config BRCM_TRACING
>>> +	bool "Broadcom device tracing"
>>> +	depends on BRCMSMAC || BRCMFMAC
>>> +	---help---
>>> +	  If you say Y here, the Broadcom wireless drivers will register
>>> +	  with ftrace to dump event information into the trace ringbuffer.
>>> +	  Tracing can be enabled at runtime to aid in debugging wireless
>>> +	  issues. This option adds a small amount of overhead when tracing
>>> +	  is disabled. If unsure, say Y to allow developers to better help
>>> +	  you when wireless problems occur.
>>> +
>>
>> I regard this as a debugging feature. Did you consider making it
>> depend on BRCMDBG instead? Or do you think that BRCMDBG code would
>> affect run-time behavior during tracing.
>
> It is a debugging feature, but making it depend on BRCMDBG prevents my
> intended use case. I'm planning to enable BRCM_TRACING in Ubuntu and to
> leave BRCMDBG disabled. This will make it easy for us to ask users for
> detailed debug information when needed with minimal overhead during
> normal use.

That seems reasonable. Have you any significant impact in throughput 
with tracing enabled?

Gr. AvS


