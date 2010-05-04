Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4072 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760158Ab0EDSWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:22:32 -0400
Message-ID: <4BE065E6.8020809@gmail.com>
Date: Tue, 04 May 2010 20:22:30 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pavel Roskin <proski@gnu.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com> <1272919385-18004-3-git-send-email-gwingerde@gmail.com> <1272920358.4907.3.camel@mj> <201005040008.36956.s.L-H@gmx.de> <1272926643.6239.1.camel@mj> <4BDF94FD.7050606@gmail.com> <20100504171720.GA21043@tuxdriver.com>
In-Reply-To: <20100504171720.GA21043@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/10 19:17, John W. Linville wrote:
> On Tue, May 04, 2010 at 05:31:09AM +0200, Gertjan van Wingerde wrote:
> 
>> To be honest, at the moment I would just change the default from 'n' to 'y'
>> for one kernel cycle, and then remove the entire option in the next kernel
>> release.
>> This is just to make it easier to revert back if for some reasons problems
>> arise with the rt30xx support.
>> The overall goal is to get rid of all these of the RT2800PCI_yyy and RT2800USB_zzz
>> symbols, but that can only happen if the devices denoted by these symbols
>> are properly supported.
>>
>> John, I leave it up to you, but for me my original patch should be merged, and
>> I'll send an equivalent patch for Stefan's one for the next kernel release.
> 
> Since the options are already inside "if RT2800PCI" and "if RT2800USB"
> blocks, I don't see why anyone should object to the boolean defaulting
> to 'y'.  It's not as if you are enabling a new driver.
> 
> I think Gertjan's proposal seems reasonable -- just don't forget! :-)
> I would suggest a feature-removal-schedlue.txt patch, but I don't
> know that it is worth the trouble.
> 

Don't worry. I won't forget. I introduced these configuration items simply to
be able to disable non-functional devices from the driver. Once all devices are
working properly I will remove all of these Kconfig variables.

Feature-removal-schedule.txt seems like a lot of overkill, as we are not actually
removing features, we are simply unconditionally enabling code.

---
Gertjan.
