Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbbHITiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 15:38:10 -0400
Message-ID: <55C7AC1D.7050602@redhat.com> (sfid-20150809_213837_829633_B5FBAD4B)
Date: Sun, 09 Aug 2015 21:38:05 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Denys Vlasenko <vda.linux@googlemail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: Deinline iwl_{read,write}{8,32}
References: <1436876558-6674-1-git-send-email-dvlasenk@redhat.com>	<55A502B6.5090806@cogentembedded.com>	<CAK1hOcPvb3mOeVm5HMqSCKAyJv47HturM+C9uxvA1=KWn94dtw@mail.gmail.com> <CANUX_P2=J81pJpyeMLEf+un=Pe8MhoGz7QJrrRUe19oeux8BhQ@mail.gmail.com>
In-Reply-To: <CANUX_P2=J81pJpyeMLEf+un=Pe8MhoGz7QJrrRUe19oeux8BhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2015 07:49 PM, Emmanuel Grumbach wrote:
> On Tue, Jul 14, 2015 at 3:41 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
>> On Tue, Jul 14, 2015 at 2:38 PM, Sergei Shtylyov
>> <sergei.shtylyov@cogentembedded.com> wrote:
>>>> +#define IWL_READ_WRITE(static_inline) \
>>>> +static_inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val) \
>>>> +{ \
>>>> +       trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val); \
>>>> +       iwl_trans_write8(trans, ofs, val); \
>>>> +} \
>>> [...]
>>>>
>>>> +#if !defined(CONFIG_IWLWIFI_DEVICE_TRACING)
>>>> +IWL_READ_WRITE(static inline)
>>>
>>>    Not static_inline?
>>
>> Yes. Here we are putting two words, "static inline", in front of every
>> function definition.
>> --
> 
> I'll try to come up with a patch that is easier for me to read, but I
> am really busy right now. Ping me in a week if you have heard from me
> earlier.

So how it is going with this patch?

In hindsight, I would use a different name for the macro parameter here:

#define IWL_READ_WRITE(static_inline) \
+static_inline void iwl_write8(...)

"static_inline" proved to be confusing.
Maybe perform s/static_inline/func_qualifier/ on the patch...

