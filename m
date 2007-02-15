Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.234]:56037 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161503AbXBOWSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 17:18:05 -0500
Received: by nz-out-0506.google.com with SMTP id s1so698919nze
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 14:18:05 -0800 (PST)
Message-ID: <a32f33a40702151418q4314f64ewf8517838a7794e63@mail.gmail.com>
Date: Thu, 15 Feb 2007 23:18:05 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070215215722.3db7f3ca@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702141423.27823.IvDoorn@gmail.com>
	 <200702151548.25041.flamingice@sourmilk.net>
	 <20070215215722.3db7f3ca@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I am not so sure that storing this information in struct ieee80211_sta_bss
> is
> > correct. As far as I can tell, that is strictly for storing information
> scan
> > results and beacon information. Nothing outside of ieee80211_sta.c uses
> it.
> > struct sta_info or struct ieee80211_if_ap (sta interfaces have a pointer
> to
> > the struct ieee80211_if_ap on the master device) may be a better choice. I
> > think struct sta_info is the right one though there is a problem - it
> isn't
> > allocated until a successful association.
>
> Thinking about it more, sdata should be the correct place. It's more
> per-interface thing than per-BSS (although the difference is small in
> this particular case).

That would also optimize the sequence handler since the BSS
does not have to be looked up anymore. I'll create the patch to do this asap.

Ivo
