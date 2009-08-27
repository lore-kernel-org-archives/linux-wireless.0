Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZH0O5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 10:57:20 -0400
Subject: Re: [PATCH] iwlagn: show_version() displays confusing/wrong
 firmware version
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251379989-20728-1-git-send-email-bjorn@mork.no>
References: <1251379989-20728-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Aug 2009 07:57:21 -0700
Message-Id: <1251385041.3805.17.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjørn,

Which kernel/repo is your patch based on?

On Thu, 2009-08-27 at 06:33 -0700, Bjørn Mork wrote:
> The output of show_version() is confusing at best, and can also be
> considered wrong

Correct. Since this information is already printed in the system logs we
determined that the version sysfs file is not needed and has been
removed. Your patch is thus not relevant to the recent code
(wireless-testing repository).

Here is the patch for your reference:

commit 44f313c2e63dcf93b17e6a43769105e487e2e49d
Author: Jay Sternberg <jay.e.sternberg@intel.com>
Date:   Fri Jul 31 14:28:09 2009 -0700

    iwlwifi: remove duplicated version info from sysfs
    
    version info in sysfs had been determined to be unnecessary as it
    is already provided in syslog info.  nvm version is added to syslog
    version info as a debug level message to provide all info that was
    in the version sysfs data.
    
    Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
    Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Reinette


