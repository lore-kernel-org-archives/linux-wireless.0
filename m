Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbYHEOrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 10:47:04 -0400
Subject: Re: Mesh network project, feedback wanted
From: Dan Williams <dcbw@redhat.com>
To: Keir <keirlawson@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e27b78a40808050438t7b5508e1oe034842427491520@mail.gmail.com>
References: <e27b78a40808050438t7b5508e1oe034842427491520@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 10:01:44 -0400
Message-Id: <1217944904.26251.53.camel@localhost.localdomain> (sfid-20080805_164708_638770_30F67EC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 12:38 +0100, Keir wrote:
> Hello,
> 
> I'm not sure if this is the right place to post this, if it's not then
> please let me know.
> 
> I am an undergraduate student currently studying software engineering,
> and am in the process of work out what my final year
> project/dissertation is going to be.  Ideally I would like to do
> something on mesh networking as it's a subject that interests me, and
> Linux is my operating system of choice.  Though I would consider
> myself fairly proficient at C, and I've studied operating systems
> though university, I haven't written any real OS code before.  Another
> limiting factor is my access to hardware.  I should be able to get my
> hands on a couple of linksys routers that can run Linux, and a couple
> of laptops, so this will make doing proper testing very difficult.
> 
> With this in mind, me and my supervisor came up with the project
> proposal that I have attached, however neither of us are hugely
> familiar with Linux mesh development.  I was wondering, does this seem
> like a sensible project proposal? Is there something better I could be
> doing given my resources?

Having spent a lot of time trying to get mesh networking going on the
OLPC project, I wouldn't spend too much time trying to do technical
stuff at layer 2 or layer 3, because that's a black hole you could
devote lots of PhD time to, and you probably want to get some actual
results in the next year.  There's already quite a few mesh routing
algorithms out there, and mesh routing is still a quite active subject
of academic research.  Just do some quick investigation of what's out
there (AODV, BATMAN, ROBIN, others), find one that allows you to get
your work done, and leave the rest alone.

The user interface and human interactions combined with local IP routing
enhancements could be the most interesting and academically relevant bit
for you.  Trying to figure out how a "mesh" should be presented to the
user, how the user "connects" to or "picks" the mesh, and how the
user/application determines that it should use the mesh (or not) are all
quite worthy questions.

Lots of people have experimented with routing protocols, framing, air
interface stuff, etc.  But I don't think there's been enough research on
_how_ mesh networks would get used by normal people and how applications
interact with the mesh itself.  We tried to push that forward with OLPC,
but that was a very targeted, specific use-case for 5 to 12 year old
primary school children.

Since you're targeting home deployment, you get to think about your
users:

If a friend who doesn't know much about computers or networking sits
down with your modified system, should they have to know if any
particular application is using the mesh or the infrastructure?

How will you give the user enough information to make an informed
decision about mesh vs. infrastructure, if your modified system requires
decisions by the user?

Can I sit down at the modified system and have it "Just Work", but can I
tweak it easily if I want/need to?  How will I know that I have to tweak
it, and why can't the system automatically tweak itself?

How will the mesh feature make my life better on a daily basis as
opposed to only infrastructure mode?

Answering some of these questions as a result of the project would make
the proposal stronger and the result more useful.

Good luck,
Dan

> Any feedback on this (even if it's just a "that's a rubbish project,
> find something else") is greatly appreciated as I have no ideal of the
> merit of the project proposal.
> 
> Cheers
> 
> Keir Lawson
> 
> "Project Proposal
> 
> Traditional home wireless networks use a central point, a wireless
> access point or router, to both connect to the outside world, the
> internet, and to connect devices within the home to each other.  An
> alternative scheme for interaction between such devices is to use ad
> hoc networks, where devices communicate directly with each other, or
> through a path constituted from intermediary devices, avoiding the
> need for a central point for routing.  With the traditional solution,
> the network has one fail point, if the router goes off-line due to a
> fault, the network cannot function, however with the potential
> mobility of home computer devices, for example laptops, an ad hoc
> solution may also be problematic.
> 
> This project will investigate combining these two network types with
> in the context of a home environment, and more specifically, will look
> at the effect of various different user and application preferences on
> route selection.  For example, a user or application could specify
> that it prefers to use a traditional managed connection in order to
> provide a level of quality of service, or another might specify that
> it does not want to cause congestion at the router and so will always
> attempt to use an ad hoc path.  Other parameters will also be
> investigated, such as reliability of connection required or speed of
> connection.
> 
> It is envisaged that the Linux implementations of routing protocols
> and the IP protocol stack will be suitably orchestrated/modified in
> order to react to user preferences over these various parameters, and
> that the resulting system will be tested using traditional home
> computing hardware, such as a wireless base station, laptops/desktops,
> and PDAs."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

