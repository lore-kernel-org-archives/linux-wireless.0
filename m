Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33856 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbGNMmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <55A502B6.5090806@cogentembedded.com>
References: <1436876558-6674-1-git-send-email-dvlasenk@redhat.com> <55A502B6.5090806@cogentembedded.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 14 Jul 2015 14:41:54 +0200
Message-ID: <CAK1hOcPvb3mOeVm5HMqSCKAyJv47HturM+C9uxvA1=KWn94dtw@mail.gmail.com> (sfid-20150714_144234_076554_36145616)
Subject: Re: [PATCH] iwlwifi: Deinline iwl_{read,write}{8,32}
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 14, 2015 at 2:38 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>> +#define IWL_READ_WRITE(static_inline) \
>> +static_inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val) \
>> +{ \
>> +       trace_iwlwifi_dev_iowrite8(trans->dev, ofs, val); \
>> +       iwl_trans_write8(trans, ofs, val); \
>> +} \
> [...]
>>
>> +#if !defined(CONFIG_IWLWIFI_DEVICE_TRACING)
>> +IWL_READ_WRITE(static inline)
>
>    Not static_inline?

Yes. Here we are putting two words, "static inline", in front of every
function definition.
