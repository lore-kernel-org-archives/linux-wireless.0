Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:44371 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3ABRAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 12:00:55 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so6542452dak.6
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 09:00:55 -0800 (PST)
Message-ID: <50E467C4.6030602@lwfinger.net> (sfid-20130102_180059_564517_7A4091D5)
Date: Wed, 02 Jan 2013 11:00:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Wollrath <jwollrath@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/wireless/mlme.c:517
References: <20130101154507.351dfb03@ilfaris> <50E325B5.205@lwfinger.net> <20130101231544.430cf1fe@ilfaris> <50E36325.3090502@lwfinger.net> <20130102120002.691dbbb4@ilfaris>
In-Reply-To: <20130102120002.691dbbb4@ilfaris>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2013 05:00 AM, Julian Wollrath wrote:

> Below is the output of a short time with debug=4 from a period where
> the interface did not manage to connect properly to the AP. Since I have
> no LED which indicates anything the lines that state
> "rtl8192ce:rtl92ce_led_control() [...]" do not seem necessary but I
> suspect there is no way to detect if there really is a state LED or is
> it?

Thanks for the debug output. There is no way for the driver to detect if there 
is an actual LED attached to that pin of the mini-PCIe connector, thus we 
program it as if one were available.
>
> The other thing, which catched my eye, were the following repeated messages:
> rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
> rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem

That sequence is due to scanning and is completely normal.

I have not looked at detail at the debug listing, but I do have additional 
questions. None of your Emails on this subject mention anything about the AP. 
What make/model is it? What firmware is it running? Is it 802.11g or 802.11n? 
What are the details of the encryption? The device authenticates but is never 
able to associate after that.

Thanks,

Larry

