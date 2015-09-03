Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45371 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750708AbbICFp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 01:45:27 -0400
Message-ID: <1441259121.10665.12.camel@coelho.fi> (sfid-20150903_074530_724538_97A1A849)
From: Luca Coelho <luca@coelho.fi>
To: Jes Sorensen <jes.sorensen@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Date: Thu, 03 Sep 2015 08:45:21 +0300
In-Reply-To: <55E71A60.9010608@gmail.com>
References: <55E71A60.9010608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi lockup problems
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Emmanuel replied to this offline, accidentally.  Just for the record,
I'll add the information here too.

On Wed, 2015-09-02 at 11:48 -0400, Jes Sorensen wrote:
> Since a while I have been experiencing issues with iwlwifi locking up
> requiring me to reconnect to my home AP. This happens both when
> connecting on 2.4GHz and on 5GHz.
> 
> This is a Fedora kernel 4.1.6-200.fc22.x86_64, but checking
> linux-2.6.git I see no updates to the driver since late July, so I
> suspect it's uptodate on that front. I have been experiencing this issue
> for about a month or so.
> 
> Attached dmesg output and the relevant portion of iw scan for the AP I
> was connected to at the time.

There are some known problems of the queues getting stuck with version 
-12 of our firmware.  The recommendation when this problem is observed
is to upgrade to version -13, which should probably be provided by your
distro already, but if not, it can be taken from the linux-firmware git
tree:

http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git

--
Cheers,
Luca.
