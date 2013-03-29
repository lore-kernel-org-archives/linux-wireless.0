Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43657 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3C2SYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 14:24:53 -0400
Received: by mail-ob0-f178.google.com with SMTP id wd20so551838obb.23
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 11:24:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com> <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
 <20130304154832.GD3021@redhat.com> <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Mar 2013 12:24:32 -0600
Message-ID: <CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com> (sfid-20130329_192458_539527_4767A40E)
Subject: Re: is L1 really disabled in iwlwifi
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 10:58 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, Mar 4, 2013 at 5:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Mon, Mar 04, 2013 at 04:57:46PM +0200, Emmanuel Grumbach wrote:
>>
>>> This is what I did. On 3.7, lspci tells me that ASPM is enabled before
>>> I load the module. And same after I load the module.
>>
>> CONFIG_PCIEASPM disabled ?
>>
>
> nope - enabled on both kernel: 3.1 and 3.7. Makes sense though.
> CONFIG_PCIEASPM enabled, I have L1. Just wondering why doesn't that
> pci_disable_link_state do anything....
> Also, I remember so issues Mathew Garret debugged and he ended up
> disabling ASPM on older kernel because some BIOS issue (don't remember
> really). Apparently, ASPM is enabled again in newer kernels.
>
> Anyway - I think I will just remove this pci_disable_link_state call
> and hopefully, it will stay long enough in linux-next so that people
> will report issues before it get into linux.
> I don't like leaving that code if it doesn't do anything.

I think we broke at least some cases of pci_disable_link_state() a
while back.  I'd like to fix it rather than just removing calls to it.

Can someone collect a complete dmesg log and "lspci -vv" output?

Bjorn
