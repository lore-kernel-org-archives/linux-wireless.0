Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:49453 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbYEMIs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:48:57 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2174688fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 01:48:55 -0700 (PDT)
Message-ID: <8704f27d0805130148t57a1dad5nf5ff535ae4ddf968@mail.gmail.com> (sfid-20080513_104900_552932_982CEC39)
Date: Tue, 13 May 2008 11:48:53 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: 11n + wpa_supplicant
Cc: "Jouni Malinen" <j@w1.fi>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>
In-Reply-To: <1210668421.3646.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 <1210667328.3646.24.camel@johannes.berg>
	 <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com>
	 <1210668421.3646.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2008-05-13 at 11:41 +0300, Emmanuel Grumbach wrote:
>  > >
>  > >  I would think that, indeed, it *is* its job since its job is
>  > >  key/algorithm selection and 11n limits the choices.
>  > >
>  >
>  > depends on priorities, maybe the security selection should limit the
>  > 11n... IMHO, security should be in higher priority since the user
>  > explicitly said he wants TKIP
>  >
>  > >  How about we simply put the 11n information element into the generic IE
>  > >  and have mac80211 use that?
>  > >
>  >
>  > in mac80211 we perfectly know what the AP supports (in
>  > ieee80211_send_assoc, I can read the IEs from the AP) , that's no the
>  > issue here, the issue is what security alg the user will chose in the
>  > 4way. This decision affects the associate even though it occurs after
>  > the association
>
>  Ah, so you mean if the user chose TKIP then we should associate as a
>  legacy STA?
>

I think so... If the AP is N-only we would be in trouble...

>  johannes
>



-- 
Emmanuel Grumbach
egrumbach@gmail.com
