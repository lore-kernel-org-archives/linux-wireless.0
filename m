Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39873 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2JNXiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 19:38:16 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so3274580iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2012 16:38:16 -0700 (PDT)
Message-ID: <507B4CE5.2020104@lwfinger.net> (sfid-20121015_013822_235386_8DB1CAA6)
Date: Sun, 14 Oct 2012 18:38:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu
Subject: Re: [RFC] rtlwifi: fix in_ep = in_ep_num mishap in _rtl_usb_init_rx
References: <201210142213.56197.chunkeey@googlemail.com>
In-Reply-To: <201210142213.56197.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2012 03:13 PM, Christian Lamparter wrote:
> in_ep and in_ep_num should not be the same as
> a device can have a different in_ep than "1".
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Note:
> This patch is related to:
> "[PATCH 3/9] rtlwifi: fix the selection of the bulk in endpoint"
>
> However, it would be much better if we can get rid of
> in_ep_num and define an in_ep array so the rtlwifi
> frameworks knows which EPs to scan. But this could be
> "too much" of an overkill, so another solution would
> be to just have a single in_ep.
>
> Larry, do you know of any hardware which has two in endpoints?

The RTL8188CU has the following:

Bus 004 Device 002: ID 0bda:8723 Realtek Semiconductor Corp.
         bEndpointAddress     0x81  EP 1 IN
         bEndpointAddress     0x02  EP 2 OUT
         bEndpointAddress     0x82  EP 2 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN

My SU device has the same layout. It seems that only EP 1 is used exclusively 
for input operations.

Larry

