Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:56612 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752601AbcDFHTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:19:40 -0400
Message-ID: <1459927177.6715.34.camel@perches.com> (sfid-20160406_091944_002785_24157D7F)
Subject: Re: [PATCH 1/7] wil6210: add function name to wil log macros
From: Joe Perches <joe@perches.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Wed, 06 Apr 2016 00:19:37 -0700
In-Reply-To: <1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
	 <1459855447-17413-2-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-05 at 14:24 +0300, Maya Erez wrote:
> Add __func__ to all wil log macros for easier debugging.

I think this is unnecessary and merely bloats code size.
For all the _dbg calls, dynamic debug can add function
names if desired.

If really desired, I suggest changing the logging
functions to use "%ps and __builtin_return_address(0)

