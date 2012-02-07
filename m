Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2BGI0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 03:26:21 -0500
Message-ID: <4F30E006.1000903@sipsolutions.net> (sfid-20120207_092645_353928_4D6F8F43)
Date: Tue, 07 Feb 2012 09:25:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/4] iwlwifi: cleanup/fix memory barriers
References: <1328544564-8696-1-git-send-email-sgruszka@redhat.com> <1328544564-8696-3-git-send-email-sgruszka@redhat.com> <4F2FFC25.8000705@sipsolutions.net> <20120207081115.GC2246@redhat.com>
In-Reply-To: <20120207081115.GC2246@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/7/2012 9:11 AM, Stanislaw Gruszka wrote:
>> Technically, PCIe bridges can reorder writes as well, so we really
>> need to do a dummy read somewhere -- we were discussing this
>> internally recently as well.
>
> PCIe can reorder writes only if they come from different CPUs,
> good examples are in "LOCKS VS I/O ACCESSES" in
> Documentation/memory-barriers.txt

Good point, I was confusing this and write posting. Don't think we have 
an issue with write posting here so we should be OK.

johannes
