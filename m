Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:63544 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYJFPLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 11:11:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so426512ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 08:11:41 -0700 (PDT)
Message-ID: <eb3ff54b0810060811p4798e4c0va59c5375d004f53d@mail.gmail.com> (sfid-20081006_171149_766512_15D136C5)
Date: Mon, 6 Oct 2008 17:11:40 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 1/2] iwlwifi: fix compliation warning in iwl-agn-rs.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <1ba2fa240810060741o35c8071ere77460305b88545c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810060658p2241a6d0k9c6f504d976e0f@mail.gmail.com>
	 <1ba2fa240810060741o35c8071ere77460305b88545c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> I prefer marking it.
> struct iwl_priv *priv = priv_r __maybe_unused;

First of all , in order to compile, this should be:
struct iwl_priv *priv __maybe_unused = priv_r;
instead of:
struct iwl_priv *priv = priv_r __maybe_unused;

 Second, this is also a possible solution; looking at the function
immediately above in the same file  (rs_clear() in iwl-agn-rs.c)
we can see the same usage of #ifdef CONFIG_IWLWIFI_DEBUG
and not __maybe_unused.
I wonder: does the  "__maybe_unused" solution better than the #ifdef
solution  in any aspect?

Regards,
Rami Rosen

On Mon, Oct 6, 2008 at 4:41 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Oct 6, 2008 at 3:58 PM, Rami Rosen <ramirose@gmail.com> wrote:
>> When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
>> we get this compilation warning:
>> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c: In
>> function 'rs_free_sta':
>> /wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-agn-rs.c:2425:
>> warning: unused variable 'priv'
>>
>> This patch (against wireless-next-2.6 tree) fixes it.
>>
>
> I prefer marking it.
> struct iwl_priv *priv = priv_r __maybe_unused;
>
