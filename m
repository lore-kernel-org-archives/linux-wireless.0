Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:30599 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYE2Vfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 17:35:50 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3102617wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 14:35:48 -0700 (PDT)
Subject: Re: [PATCH 15/37] wireless: use get/put_endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1212096681.10109.0.camel@johannes.berg>
References: <1212092308.28403.117.camel@brick>
	 (sfid-20080529_221900_617991_210BEC75)  <1212096681.10109.0.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 29 May 2008 14:35:45 -0700
Message-Id: <1212096945.28403.141.camel@brick> (sfid-20080529_233553_755487_1CF631B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-29 at 23:31 +0200, Johannes Berg wrote:
> > -	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
> > +	ADM8211_CSR_WRITE(BSSID0, get_le32((__le32 *)bssid));
> 
> Maybe I'm stupid, but isn't this the same as le32_to_cpup? Or does
> get_le32 handle unaligned values?
> 
> johannes

You're not stupid, but there is a new put_le32 as well that takes
aligned values similar to the put_unaligned_le32, so get_le32 was
added to have an analog to get_unaligned_le32 as well.

Harvey

