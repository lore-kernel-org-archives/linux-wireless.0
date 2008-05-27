Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.229]:33022 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYE0Ml7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 08:41:59 -0400
Received: by qb-out-0506.google.com with SMTP id q10so5887779qbq.15
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 05:41:57 -0700 (PDT)
Message-ID: <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com> (sfid-20080527_144202_469890_E0A37FC6)
Date: Tue, 27 May 2008 15:41:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20080527T105701-941@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 1:58 PM, JMF <tolas_feup@hotmail.com> wrote:
> Tomas Winkler <tomasw@...> writes:
>
>> WEP key is of fixed size 13 or  5 bytes, this setting should be
>> refused somewhere in the mac wext handler.
>> NACK.
>> Tomas
>  What about 256-bit WEP key (232-bit key I think), it won't be supported?
>
Not supported by iwlwifi HW, have to be done by SW, We need to check
then probably in driver whether we support it or not and return error
value in this case, in other cases I'm not sure how defensive the code
should be....
By the way isn't this a waste of bits. AES seams to be  secure enough.
Who is implementing this at all?

Thanks
Tomas
Tomas
