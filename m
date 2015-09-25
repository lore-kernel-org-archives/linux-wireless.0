Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v094114.home.net.pl ([79.96.170.134]:61450 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932955AbbIYT6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 15:58:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linaro-kernel@lists.linaro.org,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iommu@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-mm@kvack.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH V4 1/2] ACPI / EC: Fix broken 64bit big-endian users of 'global_lock'
Date: Fri, 25 Sep 2015 22:26:22 +0200
Message-ID: <4331507.W3ZDWldbWu@vostro.rjw.lan> (sfid-20150925_215817_136446_07065E5C)
In-Reply-To: <20150925185256.GG5951@linux>
References: <e28c4b4deaf766910c366ab87b64325da59c8ad6.1443198783.git.viresh.kumar@linaro.org> <1443206945.2161.9.camel@sipsolutions.net> <20150925185256.GG5951@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, September 25, 2015 11:52:56 AM Viresh Kumar wrote:
> On 25-09-15, 20:49, Johannes Berg wrote:
> > Ok, then, but that means Rafael is completely wrong ...
> > debugfs_create_bool() takes a *pointer* and it needs to be long-lived,
> > it can't be on the stack. You also don't get a call when it changes.
> 
> Ahh, ofcourse. My bad as well...

Well, sorry about the wrong suggestion.

> I think we can change structure definition but will wait for Rafael's
> comment before that.

OK, change the structure then.

Thanks,
Rafael

