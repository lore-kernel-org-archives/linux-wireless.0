Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63317 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZHTIwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 04:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <4A8C48BA.1000009@dell.com>
References: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
	 <1250707376.8073.4.camel@johannes.local> <4A8C48BA.1000009@dell.com>
Date: Thu, 20 Aug 2009 09:52:44 +0100
Message-ID: <9b2b86520908200152m28daa816ib8c54a423e63ca1a@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	cezary.jackiewicz@gmail.com, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/19/09, Mario Limonciello <mario_limonciello@dell.com> wrote:
> Johannes:
>
> Johannes Berg wrote:
>> On Wed, 2009-08-19 at 13:36 -0500, Mario Limonciello wrote:
>>
>>
>>
>>
>> Isn't that missing sysfs_remove_group()?
>>
>> johannes
>>
> The third patch in the (updated) series is dropping the sysfs bits, so
> sysfs_remove_group is removed there.

That's not ideal.  Each patch should stand on its own; it's bad form
to introduce a bug in one patch and fix it in the next one.  Even
something obscure like omitting to free the sysfs group when
setup_rfkill() fails.

I would suggest merging these two patches into one. That would avoid
adding sysfs_remove_group() in this patch, just to remove it in the
next one.  It also avoids the question in this patch, of what happens
to the rfkill interface if you write to the sysfs file.

Alan
