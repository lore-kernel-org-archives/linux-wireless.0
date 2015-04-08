Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42992 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbbDHHpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 03:45:00 -0400
Message-ID: <1428479094.2809.3.camel@sipsolutions.net> (sfid-20150408_094525_725067_B5A30621)
Subject: Re: [PATCH] iwlwifi: Move each system tracepoints to their own
 header
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Date: Wed, 08 Apr 2015 09:44:54 +0200
In-Reply-To: <20150407121319.72d69ec5@gandalf.local.home>
References: <20150406231357.2b8e452d@grimm.local.home>
	 <1428389938.1841.1.camel@sipsolutions.net>
	 <20150407102146.216cf90b@gandalf.local.home>
	 <20150407121319.72d69ec5@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-07 at 12:13 -0400, Steven Rostedt wrote:
> Every tracing file must have its own TRACE_SYSTEM defined.
> The iwlwifi tracepoint header broke this and added in the middle
> of the file:
[...]
> Unfortunately, this broke new code in the ftrace infrastructure.
> Moving each of these TRACE_SYSTEMs into their own trace file with
> just one TRACE_SYSTEM per file fixes the issue.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


>  drivers/net/wireless/iwlwifi/iwl-devtrace-data.h   |  79 ++++
>  drivers/net/wireless/iwlwifi/iwl-devtrace-io.h     | 155 ++++++++
>  .../net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h    | 200 ++++++++++
>  drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h    |  97 +++++
>  drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h  |  81 ++++
>  drivers/net/wireless/iwlwifi/iwl-devtrace.h        | 438 +--------------------
>  6 files changed, 618 insertions(+), 432 deletions(-)
>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-io.h
>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h
>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h

Looks good to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

