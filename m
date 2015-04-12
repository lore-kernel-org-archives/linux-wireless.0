Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35749 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbDLRha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2015 13:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <1428479094.2809.3.camel@sipsolutions.net>
References: <20150406231357.2b8e452d@grimm.local.home>
	<1428389938.1841.1.camel@sipsolutions.net>
	<20150407102146.216cf90b@gandalf.local.home>
	<20150407121319.72d69ec5@gandalf.local.home>
	<1428479094.2809.3.camel@sipsolutions.net>
Date: Sun, 12 Apr 2015 20:37:29 +0300
Message-ID: <CANUX_P36HE+efTSvVYV5tYC01vNzoQKcLVECsH7QJXHPGirYdw@mail.gmail.com> (sfid-20150412_193747_323040_BCC30B43)
Subject: Re: [PATCH] iwlwifi: Move each system tracepoints to their own header
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 8, 2015 at 10:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-04-07 at 12:13 -0400, Steven Rostedt wrote:
>> Every tracing file must have its own TRACE_SYSTEM defined.
>> The iwlwifi tracepoint header broke this and added in the middle
>> of the file:
> [...]
>> Unfortunately, this broke new code in the ftrace infrastructure.
>> Moving each of these TRACE_SYSTEMs into their own trace file with
>> just one TRACE_SYSTEM per file fixes the issue.
>>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
>
>>  drivers/net/wireless/iwlwifi/iwl-devtrace-data.h   |  79 ++++
>>  drivers/net/wireless/iwlwifi/iwl-devtrace-io.h     | 155 ++++++++
>>  .../net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h    | 200 ++++++++++
>>  drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h    |  97 +++++
>>  drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h  |  81 ++++
>>  drivers/net/wireless/iwlwifi/iwl-devtrace.h        | 438 +--------------------
>>  6 files changed, 618 insertions(+), 432 deletions(-)
>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-io.h
>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h
>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h
>
> Looks good to me.
>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>

I had to make quite a few modifications since this patch was not based
on iwlwifi-next, but I picked it up in our internal tree.
