Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbeHII6n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 04:58:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 09 Aug 2018 12:05:23 +0530
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: Jasmine Strong <jas@eero.com>
Cc: Ben Greear <greearb@candelatech.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCHv2] ath10k : Fix channel survey dump
Message-ID: <d586156d3861a6cf0f479ff12ddd6544@codeaurora.org> (sfid-20180809_083526_556306_2863BB55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-01 00:03, Jasmine Strong wrote:
> On Tue, Jul 31, 2018 at 10:38 AM Ben Greear <greearb@candelatech.com>
> wrote:
> 
>> On 07/31/2018 05:11 AM, Venkateswara Naralasetty wrote:
>>> Channel active/busy time are showing incorrect(less than previous
>> or
>>> sometimes zero) for successive survey dump command.
>>> 
>>> example:
>>> Survey data from wlan0
>>> frequency:                      5180 MHz [in use]
>>> channel active time:            54995 ms
>>> channel busy time:              432 ms
>>> channel receive time:           0 ms
>>> channel transmit time:          59 ms
>>> Survey data from wlan0
>>> frequency:                      5180 MHz [in use]
>>> channel active time:            32592 ms
>>> channel busy time:              254 ms
>>> channel receive time:           0 ms
>>> channel transmit time:          0 ms
>>> 
>>> This patch fix this issue by assigning 'wmi_bss_survey_req_type'
>>> as 'WMI_BSS_SURVEY_REQ_TYPE_READ' which accumulate survey data in
>>> FW and send survey data to driver upon the driver request. Wrap
>> around
>>> is taken care by FW.
>>> 
>>> hardware used : QCA9984
>>> firmware ver  : ver 10.4-3.5.3-00057
>> 
>> Have you tested this on other firmwares?  I am pretty sure that at
>> least
>> some of them, probably 10.2, will have issues.
>> 
>> Maybe you could make this change specific to certain firmware that
>> is known to work with the change?
> 
> There are bigger problems with it than that;  even with firmwares that
> behave correctly,
> this changes the behavior that a lot of upper-layer software depends
> upon, and will likely
> make anything that actually uses the channel survey data misbehave.
> 
> It is therefore a breaking change for any device that actually
> implements ACS.
> 
> -J.

In ath9k driver also survey data being accumulated in driver and send 
survey data to user space is accumulated one. same thing we are 
implementing in FW(with WMI request type WMI_BSS_SURVEY_REQ_TYPE_READ) 
instead of doing it in driver.

Thanks,
Venkatesh.
