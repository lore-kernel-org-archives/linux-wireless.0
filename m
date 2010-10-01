Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39817 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659Ab0JAXCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 19:02:05 -0400
From: Anand Gadiyar <gadiyar@ti.com>
References: <1285965236-17907-1-git-send-email-gadiyar@ti.com> <AANLkTi=+dtqdZLb8rfu8NZRU5GceUL5+S3B=MeW1xF=M@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <AANLkTi=+dtqdZLb8rfu8NZRU5GceUL5+S3B=MeW1xF=M@mail.gmail.com>
Date: Sat, 2 Oct 2010 04:32:04 +0530
Message-ID: <cf2c8b9dc6762d53dcaf522d874cb37b@mail.gmail.com>
Subject: RE: [PATCH] omap: zoom2: fix build break when CONFIG_WL12XX_PLATFORM_DATA=n
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen wrote:
> On Fri, Oct 1, 2010 at 10:33 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> > Fix this build break when CONFIG_WL12XX_PLATFORM_DATA is not set.
>
> A similar fix was already submitted and is pending to be merged
> (http://permalink.gmane.org/gmane.linux.kernel.wireless.general/56595)
>
> > There are still many warnings about the function
wl12xx_set_platform_data
> > being unused. Haven't fixed those. Ohad, care to take a look?
>
> Sure. Which warnings do you refer to (I haven't seen any) ?
>

I picked up your patch and the warnings are gone. The key difference
was I missed marking the alternative function as an inline.

Without that, I was seeing warnings like these:
include/linux/wl12xx.h:42: warning: 'wl12xx_set_platform_data' defined but
not used

- Anand
