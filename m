Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8358 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYADWNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 17:13:14 -0500
To: Miguel =?iso-8859-1?Q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com, linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
References: <200801042305.55188.mboton@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 04 Jan 2008 14:13:12 -0800
In-Reply-To: <200801042305.55188.mboton@gmail.com> (Miguel
 =?iso-8859-1?Q?Bot=C3=B3n's?= message of "Fri, 4 Jan 2008 23:05:54 +0100")
Message-ID: <adaabnlme87.fsf@cisco.com> (sfid-20080104_221318_806972_FA792F1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > -			       "radiotap head [%d]\n",
 > +			       "radiotap head [%ld]\n",
 >  			       skb_headroom(skb), sizeof(*iwl4965_rt));

Actually I think the correct printf format for printing a size_t
(coming here from sizeof foo) is "%zd".  Otherwise you'll fix the
warning on 64-bit targets but add a new warning on 32-bit targets.

 - R.
