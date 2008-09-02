Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:5721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYIBWtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 18:49:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2211949fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 15:49:09 -0700 (PDT)
Message-ID: <1ba2fa240809021549g32bb4182r416b4114394ec1bb@mail.gmail.com> (sfid-20080903_004915_205160_65AD4387)
Date: Wed, 3 Sep 2008 01:49:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>,
	"Mohamed Abbas" <mohamed.abbas@intel.com>
In-Reply-To: <20080902210101.GE3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <20080902210101.GE3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2008 at 12:01 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Aug 28, 2008 at 05:25:07PM +0800, Zhu Yi wrote:
>> From: Gregory Greenman <gregory.greenman@intel.com>
>>
>> This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
>> accordingly. Without this patch hardware consumes power even after driver
>> is removed or suspended.
>>
>> Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
>> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>
> The two hunks of this patch seem like two different fixes, and the
> changelog only matches the first hunk.  When you resubmit this series
> (which I presume you will be doing with better changelogs after
> Marcel's commentary), please split this into two patches.
>
It's not so obvious form the reading the patch but these two hunks
belongs together. Without the second hunk the exit flow is not correct
and first hunk fix has no effect.  Although I don't mind to split them
providing it's easier to swallow.
Thanks
Tomas
