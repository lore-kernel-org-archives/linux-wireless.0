Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16682 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYCTDqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 23:46:45 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] iwlwifi: prevent tuning during scanning
Date: Wed, 19 Mar 2008 20:46:43 -0700
Message-ID: <33E1C72C74DBE747B7B59C1740F7443702FFB902@orsmsx417.amr.corp.intel.com> (sfid-20080320_034656_029787_FFD255A0)
In-Reply-To: <1205971612.16475.87.camel@johannes.berg>
References: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_234534_228497_EC4DD4E8) <1205971612.16475.87.camel@johannes.berg>
From: "Abbas, Mohamed" <mohamed.abbas@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can not call any host command that change active channel during
scanning. Actually we do cancel scan if config callback was called
during scanning. So if a user tried to change channel while scanning
this patch will delay the channel change until scan finish, this is the
same behavior as sw scan.
Mohamed


-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Wednesday, March 19, 2008 5:07 PM
To: Chatre, Reinette
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org;
ipw3945-devel@lists.sourceforge.net; Abbas, Mohamed
Subject: Re: [PATCH] iwlwifi: prevent tuning during scanning

Wrong patch title. Trying to sneak patches past me? ;)

Also, I thought you explicitly wanted the channel change callback to be
allowed during hw scan because hw scan could return to the home channel
inbetween...

johannes
