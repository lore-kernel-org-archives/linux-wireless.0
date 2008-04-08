Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:40201 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbYDHTEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 15:04:11 -0400
Date: Tue, 8 Apr 2008 14:04:03 -0500
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080408140403.3e7191bb@speedy> (sfid-20080408_200417_151768_1C5ABFF6)
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at the kernel/user interface: wimax-tools-1.1/lib/op-open.c

This API is repeating the mistake of the old Linux Wireless API. It is putting version
checks between kernel and library and this is a maintenance nightmare. Linux
API's are not COM. Versioning is a mistake.  Use a TLA api like netlink so it
can be extensible without version handshake.
