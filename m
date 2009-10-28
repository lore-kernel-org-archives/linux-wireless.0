Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:38403 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbZJ1OrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 10:47:21 -0400
Received: by qyk4 with SMTP id 4so509466qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2009 07:47:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256676190.4237.27.camel@johannes.local>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
	 <1256676190.4237.27.camel@johannes.local>
Date: Wed, 28 Oct 2009 10:47:25 -0400
Message-ID: <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
Subject: Re: iwlist wlan0 scan disrupts communications
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2009 at 4:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-10-27 at 16:40 -0400, Charles Gordon wrote:
>> Hi,
>>
>> I am using version 2.6.28 of the kernel and version 0.9.11-nogit of
>> iw.  Communications are disrupted and the device stops responding to
>> ping when I use the command "iwlist wlan0 scan".  Communications are
>> restored when the command completes.  Is this behavior expected?  Has
>> it been fixed in a later release?
>
> Yes and yes, but I don't remember whether it's better in 2.6.31 or only
> will be in 32.
>
> johannes
>
Thanks for the information.  After doing some more testing I found
that the association to the AP is sometimes lost and that mac80211
does not recover automatically.  You have to type the command "wpa_cli
reassociate" to trigger the stack to reassociate with the AP.  Is this
one of the things that is, or will be, fixed in later releases?
