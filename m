Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:33271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYELMWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 08:22:45 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3456976waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 05:22:45 -0700 (PDT)
Message-ID: <1ba2fa240805120522m26904f72l45941b1beb411e60@mail.gmail.com> (sfid-20080512_142249_249371_BE208795)
Date: Mon, 12 May 2008 15:22:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: dynamic wep with mulitple keys
Cc: "Emmanuel Grumbach" <egrumbach@gmail.com>,
	"Volker Braun" <vbraun@physics.upenn.edu>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <f6ca9fed0805120510yec6ba9fge41c46d2d01c236a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
	 <f6ca9fed0805060022s1f22e09ay5ac20b5ecd08ab9a@mail.gmail.com>
	 <8704f27d0805060032g2312e7dcwc19f382c431e6cd3@mail.gmail.com>
	 <f6ca9fed0805060510l36c72666v414dfd989625d18e@mail.gmail.com>
	 <8704f27d0805060514i59db36f0t9801fab7543b8655@mail.gmail.com>
	 <f6ca9fed0805120447wf6c1c38mea24ba587dc834d4@mail.gmail.com>
	 <1ba2fa240805120507r2914d23dt6826a732730fea49@mail.gmail.com>
	 <f6ca9fed0805120510yec6ba9fge41c46d2d01c236a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 3:10 PM, drago01 <drago01@gmail.com> wrote:
> On Mon, May 12, 2008 at 2:07 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>>
>> On Mon, May 12, 2008 at 2:47 PM, drago01 <drago01@gmail.com> wrote:
>>  > On Tue, May 6, 2008 at 2:14 PM, Emmanuel Grumbach
<egrumbach@gmail.com> wrote:
>>  >>
>>  >> On Tue, May 6, 2008 at 3:10 PM, drago01 <drago01@gmail.com> wrote:
>>  >>  >
>>  >>  > On Tue, May 6, 2008 at 9:32 AM, Emmanuel Grumbach
>>  <egrumbach@gmail.com> wrote:
>>  >>  >  >
>>  >>  >  > On Tue, May 6, 2008 at 10:22 AM, drago01 <drago01@gmail.com> wrote:
>>  >>  >  >  > On Tue, May 6, 2008 at 8:46 AM, Emmanuel Grumbach
>>  <egrumbach@gmail.com> wrote:
>>  >>  >  >  >  > >  I just tried compat-wireless-2008-05-05, which
does contain
>>  >>  >  >  >  >  >  03dcb07e74a62eec2badb9f6a091790c484f4a6c. No difference:
>>  >>  >  >  >  >  >
>>  >>  >  >  >  >
>>  >>  >  >  >  >  Thanks for trying this.
>>  >>  >  >  >  >  Can you try to load the module with swcrypto=1 and
try again ?
>>  >>  >  >  >  >  This disables the HW encryption acceleration. Trying
>>  this will allow
>>  >>  >  >  >  >  to make 100% sure that the bug is in iwlwifi. The bug
>>  is likely to be
>>  >>  >  >  >  >  there, but I think it is worth to make this 100% sure.
>>  >>  >  >  >
>>  >>  >  >  >  Well it happens for me with iwl3945 which uses swcrypto
>>  by default see:
>>  >>  >  >  >
>>  >>  >  >  >  http://marc.info/?l=linux-wireless&m=120699235803881&w=2
>>  >>  >  >  >
>>  >>  >  >
>>  >>  >  >  Actually, I made quite a lot of changes in security in
iwl4965 that
>>  >>  >  >  are not in iwl3945 so I think it is worth trying with
iwl4965 in SW.
>>  >>  >  >  The security code is not the same between 3945 and 4965
>>  >>  >
>>  >>  >  OK, are you planning to port this changes/fixes to 3945 ?
>>  >>  >
>>  >>
>>  >>  Well... Low priority...
>>  >
>>  > This changes fix an important bug that otherwise make the driver
>>  > useless in some configurations.
>>  > So I think it should be backported to 3945 (even when development is
>>  > focused on newer hardware)
>>
>>  But 3945 uses SW encryption this fix is for HW crypto.
>
> I was talking about this:
> "Actually, I made quite a lot of changes in security in iwl4965 that
> are not in iwl3945 so I think it is worth trying with iwl4965 in SW.
> The security code is not the same between 3945 and 4965"
> which seemed to work for Volker using swcrypto

SW crypto is handled by mac80211 so I ponder why it works above 4965
and not over 3945 but it has nothing to do with this particular change


Thanks
Tomas
