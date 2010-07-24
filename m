Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0GXEeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 00:34:46 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: drago01 <drago01@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Jul 2010 21:34:43 -0700
Subject: RE: iwlagn and many firmware restarts with Fedora kernel
Message-ID: <E9954878DD1FB34FAE5187FB88C58A350120C54D7D@orsmsx506.amr.corp.intel.com>
References: <1279565034.4572.36.camel@localhost.localdomain>
	<AANLkTinGUQjPoMRmt_jeFgpxLhzma7qhfR14t_tWLvO1@mail.gmail.com>
	<1279582174.4572.43.camel@localhost.localdomain>
	<1279583798.28066.3.camel@wwguy-ubuntu>
	<AANLkTinJrjvSUuOSeb6fQESN-T789wWCU1ezRXwQ3KXK@mail.gmail.com>
	<1279744628.6548.0.camel@wwguy-ubuntu>
	<AANLkTilxa09Cqn3icsTRAULhKBPzv5evOVPTqI-GrYiU@mail.gmail.com>
	<1279823849.32290.1.camel@wwguy-ubuntu>
 <AANLkTi=qKLVEKKKopWdnxS41ny5S6zV6RSCptSE+a8Sf@mail.gmail.com>
In-Reply-To: <AANLkTi=qKLVEKKKopWdnxS41ny5S6zV6RSCptSE+a8Sf@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi drago,

-----Original Message-----
From: drago01 [mailto:drago01@gmail.com]
Sent: Friday, July 23, 2010 3:32 PM
To: Guy, Wey-Yi W
Cc: Marcel Holtmann; linux-wireless@vger.kernel.org
Subject: Re: iwlagn and many firmware restarts with Fedora kernel

On Thu, Jul 22, 2010 at 8:37 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi drago,
>
>
> On Wed, 2010-07-21 at 14:00 -0700, drago01 wrote:
>> On Wed, Jul 21, 2010 at 10:37 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> > Hi drago,
>> > On Wed, 2010-07-21 at 12:59 -0700, drago01 wrote:
>> >> On Tue, Jul 20, 2010 at 1:56 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> >> > Hi drago,
>> >> >
>> >> >
>> >> > Are you using 5350? here I attach a "RFC patch", could you give a try to
>> >> > see if it help?
>> >>
>> >> Not quite I am on 5300; your patch seem to only touch the 5350 code
>> >> ... should I try the same change for 5300?
>> >
>> > Yes, please
>>
>> Hi,
>>
>> As there is no such field in .34 I patched the .35 driver which seems
>> to be fine with the change ... I couldn't trigger it using the close
>> lid (no suspend) and wait a bit trick ... but I have not used it for
>> long enough to say for certain that its gone.
>>
>> But unfortunately the driver has a different issue it spams my log with tons of:
>>
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>> iwlagn 0000:02:00.0: BA scd_flow 0 does not match txq_id 10
>>
> Yes, I aware of this, this is introduced by a recent patch
> commit d9763a384216336e180399b69461eae37f6c4f54
>
> I will work on a new patch to help address this.

OK, as for the other patch after a day in use I could not trigger the
problem so it does indeed fix it.

Great, thank you very much for testing it. I will prepare the patch for upstream.

Btw, I also have patch to help the other problem you encounter.

Wey
