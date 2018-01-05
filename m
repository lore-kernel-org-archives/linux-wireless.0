Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbeAEBpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 20:45:12 -0500
Date: Fri, 5 Jan 2018 02:45:10 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/6] wl1251: Fix MAC address for Nokia N900
Message-ID: <20180105014510.GB22430@wotan.suse.de> (sfid-20180105_024533_416004_09078D97)
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
 <20180102192345.dnywuv4sapltrfrl@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20180102192345.dnywuv4sapltrfrl@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 02, 2018 at 08:23:45PM +0100, Pali Rohár wrote:
> On Friday 10 November 2017 00:38:22 Pali Rohár wrote:
> > This patch series fix processing MAC address for wl1251 chip found in Nokia N900.
> > 
> > Changes since v1:
> > * Added Acked-by for Pavel Machek
> > * Fixed grammar
> > * Magic numbers for NVS offsets are replaced by defines
> > * Check for validity of mac address NVS data is moved into function
> > * Changed order of patches as Pavel requested
> > 
> > Pali Rohár (6):
> >   wl1251: Update wl->nvs_len after wl->nvs is valid
> >   wl1251: Generate random MAC address only if driver does not have
> >     valid
> >   wl1251: Parse and use MAC address from supplied NVS data
> >   wl1251: Set generated MAC address back to NVS data
> >   firmware: Add request_firmware_prefer_user() function
> >   wl1251: Use request_firmware_prefer_user() for loading NVS
> >     calibration data
> > 
> >  drivers/base/firmware_class.c          |   45 +++++++++++++-
> >  drivers/net/wireless/ti/wl1251/Kconfig |    1 +
> >  drivers/net/wireless/ti/wl1251/main.c  |  104 ++++++++++++++++++++++++++------
> >  include/linux/firmware.h               |    9 +++
> >  4 files changed, 138 insertions(+), 21 deletions(-)
> 
> Hi! Are there any comments for first 4 patches? If not, could they be
> accepted and merged?

Since the first 4 patches do not touch the firmware API they seem fine to me so
long as the maintainer accepts them. Maybe resend and clarify you have dropped
the other ones and amend with the new tags.

  Luis
