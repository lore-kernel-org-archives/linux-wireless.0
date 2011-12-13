Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36574 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1LMUlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:41:06 -0500
Received: by eekc4 with SMTP id c4so82234eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 12:41:05 -0800 (PST)
Message-ID: <4EE7B85E.3070802@lwfinger.net> (sfid-20111213_214111_041580_F6E84156)
Date: Tue, 13 Dec 2011 14:41:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <20111118225422.GD19138@thinkpad-t410> <4EC88F58.1080203@lwfinger.net> <20111121181350.GC6736@thinkpad-t410> <4ECA99CC.7020008@lwfinger.net> <20111121185610.GD6736@thinkpad-t410> <4ECB028E.3030809@lwfinger.net> <20111122022008.GA17661@thinkpad-t410> <20111213194231.GA30788@thinkpad-t410>
In-Reply-To: <20111213194231.GA30788@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2011 01:42 PM, Seth Forshee wrote:
> I have another AP that the rtl8192ce doesn't have any problems
> associating with, so I also captured a trace with wireshark when
> associating to that AP. I didn't see much that differed except that the
> probe response frame with the problematic AP is about 350 bytes longer
> (due to additional information elements).

The extra IE entries must be the clue.

> Something else that I noticed is that with the problematic AP, inactive
> power save seems to kick in shortly afer sending the
> probe/authentication requests. I wondered if this might be behind the
> issues, but loading the module with ips=0 makes no difference.
>
> Any suggestions on what might be going wrong or next steps for
> debugging?

With ips=0, all power save should be eliminated. Please take the two capture 
files, and filter all but the probe and probe response frames. I'll try to find 
some time to analyze them.

Larry
