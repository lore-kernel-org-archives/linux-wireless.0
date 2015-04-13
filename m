Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:34955 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbbDMGWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 02:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <CANUX_P36HE+efTSvVYV5tYC01vNzoQKcLVECsH7QJXHPGirYdw@mail.gmail.com>
References: <20150406231357.2b8e452d@grimm.local.home>
	<1428389938.1841.1.camel@sipsolutions.net>
	<20150407102146.216cf90b@gandalf.local.home>
	<20150407121319.72d69ec5@gandalf.local.home>
	<1428479094.2809.3.camel@sipsolutions.net>
	<CANUX_P36HE+efTSvVYV5tYC01vNzoQKcLVECsH7QJXHPGirYdw@mail.gmail.com>
Date: Mon, 13 Apr 2015 09:22:37 +0300
Message-ID: <CANUX_P17eRZxGmi-RrYZPO1Acyfk_dvSbOh=XAsCe=7-Cs_Wsw@mail.gmail.com> (sfid-20150413_082253_836775_807EAA7D)
Subject: Re: [PATCH] iwlwifi: Move each system tracepoints to their own header
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 12, 2015 at 8:37 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Wed, Apr 8, 2015 at 10:44 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2015-04-07 at 12:13 -0400, Steven Rostedt wrote:
>>> Every tracing file must have its own TRACE_SYSTEM defined.
>>> The iwlwifi tracepoint header broke this and added in the middle
>>> of the file:
>> [...]
>>> Unfortunately, this broke new code in the ftrace infrastructure.
>>> Moving each of these TRACE_SYSTEMs into their own trace file with
>>> just one TRACE_SYSTEM per file fixes the issue.
>>>
>>> Cc: Johannes Berg <johannes@sipsolutions.net>
>>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>
>>
>>>  drivers/net/wireless/iwlwifi/iwl-devtrace-data.h   |  79 ++++
>>>  drivers/net/wireless/iwlwifi/iwl-devtrace-io.h     | 155 ++++++++
>>>  .../net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h    | 200 ++++++++++
>>>  drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h    |  97 +++++
>>>  drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h  |  81 ++++
>>>  drivers/net/wireless/iwlwifi/iwl-devtrace.h        | 438 +--------------------
>>>  6 files changed, 618 insertions(+), 432 deletions(-)
>>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
>>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-io.h
>>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h
>>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-msg.h
>>>  create mode 100644 drivers/net/wireless/iwlwifi/iwl-devtrace-ucode.h
>>
>> Looks good to me.
>>
>> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>>
>
> I had to make quite a few modifications since this patch was not based
> on iwlwifi-next, but I picked it up in our internal tree.

Wait - you seemed to want to apply that on your tree because of
dependencies (which I can understand). So how do you suggest to
proceed?
You can apply your original version of the patch on your tree, but
then it'll collapse when it'll meet iwlwifi-next.git.
I can try to have the modified version of the patch into 4.1 but I
doubt I'll make it. If I do make it, it'd allow you to work on top of
4.1 whenever that'll be ready? What is your timeline?

Or maybe you can pull iwlwifi-next (which would be odd I have to say)?
What do you suggest?
FWIW - I am talking about:

commit 7e1223b50089ab5901215d2fd8c61b42c7cfe034
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue Feb 3 20:11:48 2015 +0200

    iwlwifi: mvm: new Alive / error table API

    The new API slightly changes the layout of the version of
    the firmware - prepare for that.

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
