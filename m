Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48649 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2B0UUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 15:20:15 -0500
Received: by wibhm11 with SMTP id hm11so1538287wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 12:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330364928.12612.15.camel@wwguy-huron>
References: <1330350725-5815-1-git-send-email-sgruszka@redhat.com>
	<1330353016.12612.13.camel@wwguy-huron>
	<CANUX_P2Xia4HgF_ooUCTRN0+EqX8dx9Wc1rFiDbiNBdgzu9k5Q@mail.gmail.com>
	<1330364928.12612.15.camel@wwguy-huron>
Date: Mon, 27 Feb 2012 22:20:14 +0200
Message-ID: <CANUX_P3JObf0OzAT4L5w7ksry89Ovz2QyAde+DZZUMR6eBt5Hw@mail.gmail.com> (sfid-20120227_212026_578034_F03C20F5)
Subject: Re: [PATCH -iwlwifi] iwlwifi: make tx_cmd_pool kmem cache global
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 19:48, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Mon, 2012-02-27 at 19:55 +0200, Emmanuel Grumbach wrote:
>> I guess that Sanislaw patch is defining one single pool for all the
>> devices, which means that we won't try to allocate a few pools with
>> the same name, which leads to this warning.
>>
> That I got it, but is really the "only" way to do it, I am really not a
> fan of global variable.
>
I guess we can have a pool for "iwl_dev_cmd_<PCI_DEV_ID>" or something
like this. But I don't see what is the problem with the global
variable besides the namespace pollution which is not very problematic
since we don't export this variable. It is a singleton in terms of
"Software design pattern" (I hate these buzzwords), and this is the
way to implement this in C AFAICT.
