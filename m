Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46608 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3KEIaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 03:30:22 -0500
Received: by mail-lb0-f171.google.com with SMTP id x18so6391308lbi.30
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 00:30:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DE641D@HASMSX103.ger.corp.intel.com>
References: <20131101102848.GI29795@longonot.mountain>
	<0BA3FCBA62E2DC44AF3030971E174FB301DE641D@HASMSX103.ger.corp.intel.com>
Date: Tue, 5 Nov 2013 10:30:21 +0200
Message-ID: <CANUX_P153qYkSgRQPS_0FaF4ux8iWT8hwzNYxA321vf48fbKxA@mail.gmail.com> (sfid-20131105_093026_063059_4323AE71)
Subject: Re: iwlwifi: mvm: BT Coex - don't limit agg size in loose scheme
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 2, 2013 at 9:41 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>
>> Hello Emmanuel Grumbach,
>>
>> This is a semi-automatic email about new static checker warnings.
>>
>> The patch 9145d15128bd: "iwlwifi: mvm: BT Coex - don't limit agg size in loose
>> scheme" from Jul 18, 2013, leads to the following Smatch
>> complaint:
>>
>> drivers/net/wireless/iwlwifi/mvm/rs.c:2491 rs_fill_link_cmd()
>>        error: we previously assumed 'mvm' could be null (see line 2412)
>
> Thanks Dan - I believe we can remove all the checks. Will send a patch.
>

Err... not true... Fixing the smatch issue the other way around... We
would have paniced in specific debug scenarios..
