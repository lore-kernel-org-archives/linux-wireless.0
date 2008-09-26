Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:2444 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYIZFkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 01:40:17 -0400
Received: by el-out-1112.google.com with SMTP id z25so183570ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 22:40:16 -0700 (PDT)
Message-ID: <43e72e890809252240h7e1e1818of75dfeafd0a8e4e2@mail.gmail.com> (sfid-20080926_074021_065763_9795D727)
Date: Thu, 25 Sep 2008 22:40:16 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <43e72e890809252239g2a6207f9r581b970388d9df14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1222401242.2510.519.camel@debian.sh.intel.com>
	 <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com>
	 <1222406884.2510.534.camel@debian.sh.intel.com>
	 <43e72e890809252239g2a6207f9r581b970388d9df14@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 10:39 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Sep 25, 2008 at 10:28 PM, Zhu Yi <yi.zhu@intel.com> wrote:
>
>> You brought it up. And I also want to discuss it. We do want to support
>> it. But the 3945/4965/5000 hardwares doesn't have the alpha2 information
>> in their EEPROMs (btw, 2100/2200 does support that). Instead, they have
>> a band/channel table including freq, tx power, etc in the EEPROM. So a
>> simple regulatory_hint() API doesn't work. We need a way to export the
>> channel details to CRDA.
>
> Yes, this detail of information was conveyed to me at OLS by Guy. This
> is why we decided to add support for letting the driver not pass an
> alpha2 but to just build the regulatory domain structure itself and
> pass it. I even provided an example of how to do this in the
> Documentation/networking/regulatory.txt and tested it myself.
>
> Essentially this was added with your drivers in mind :)
>
> Let me know if you run into any issues.

Oh and to be clear -- you "can" also pass an alpha2 if you guys do
figure out a way to do that. If not its OK, just set the alpha2 to
NULL.

  Luis
