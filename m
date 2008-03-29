Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:28730 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYC2LhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 07:37:02 -0400
Received: by py-out-1112.google.com with SMTP id u52so970592pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 04:37:01 -0700 (PDT)
Message-ID: <c68f135e0803290437m5177bf96x4e3796fcee9253c7@mail.gmail.com> (sfid-20080329_113716_614674_BBFAE518)
Date: Sat, 29 Mar 2008 12:37:01 +0100
From: "Andrea Merello" <andreamrl@tiscali.it>
Reply-To: andreamrl@tiscali.it
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335 [Libertas]"
Cc: "Markus Becker" <mab@comnets.uni-bremen.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	julian.calaby@gmail.com, david@woodhou.se, dwmw2@infradead.org
In-Reply-To: <1206712285.2255.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
	 <200803191124.03743.hs4233@mail.mn-solutions.de>
	 <Pine.LNX.4.64.0803281122240.21835@bugs.comnets.uni-bremen.de>
	 <1206712285.2255.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver was dead, for me, due to my short of time.
A huge thank to all people that work on it making it live again!!

Andrea

On Fri, Mar 28, 2008 at 2:51 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2008-03-28 at 14:36 +0100, Markus Becker wrote:
>  > Dear John,
>  >
>  > as suggested by Holger Schurig, I would like to have the driver mrv8k for
>  > devices with "Marvell 88w8335 [Libertas]" chipset (11ab:1faa) integrated
>  > into wireless-testing. The driver has still some problems, but we hope
>  > that more visibility would increase the number of people knowing about
>  > this driver and helping in improving it.
>
>  Awesome, great to see movement on this.  Will try to review bits and
>  test it out later today.
>
>  Dan
>
>
>
>  > On Wed, 19 Mar 2008, Holger Schurig wrote:
>  > > However, my advice is the following: As long as the driver's home
>  > > is on some "obscure" tar files, it will always suffer from
>  > > bitrot and not-so-much contribution by third partis. So aim to
>  > > bring the driver into the linux kernel. Talk with John W.
>  > > Linville on the linux-wireless mailing list about this.
>  > > http://linuxwireless.org should give you pointers. For drivers,
>  > > sometimes Linux accepts even not-so-good-code, when there is a
>  > > chance that the beast get's better via re-factoring over time.
>  >
>  > There is some more information in
>  > http://thread.gmane.org/gmane.linux.kernel.wireless.general/12645
>  >
>  > Since then I have ported it to wireless-testing, but still setting the
>  > channels is not working.
>  >
>  > If changes are needed to the patch, I would be happy to perform them.
>  >
>  > Best regards,
>  > Markus
>  >
>  > Signed-off-by: Markus Becker <mab@comnets.uni-bremen.de>
>  >
>  > diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>  > index fa8ab13..9d6cc65 100644
>  > --- a/drivers/net/wireless/Kconfig
>  > +++ b/drivers/net/wireless/Kconfig
>  > @@ -753,5 +753,6 @@ source "drivers/net/wireless/b43/Kconfig"
>  >   source "drivers/net/wireless/b43legacy/Kconfig"
>  >   source "drivers/net/wireless/zd1211rw/Kconfig"
>  >   source "drivers/net/wireless/rt2x00/Kconfig"
>  > +source "drivers/net/wireless/mrv8k/Kconfig"
>  >
>  >   endmenu
>  > diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
>  > index 3af665d..0c4002b 100644
>  > --- a/drivers/net/wireless/Makefile
>  > +++ b/drivers/net/wireless/Makefile
>  > @@ -67,3 +67,4 @@ obj-$(CONFIG_P54_USB)               += p54usb.o
>  >   obj-$(CONFIG_P54_PCI)               += p54pci.o
>  >
>  >   obj-$(CONFIG_ATH5K) += ath5k/
>  > +obj-$(CONFIG_MRV8K) += mrv8k/
>  > diff --git a/drivers/net/wireless/mrv8k/COPYING b/drivers/net/wireless/mrv8k/COPYING
>  > new file mode 100644
>  > index 0000000..e90dfed
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/COPYING
>  > @@ -0,0 +1,340 @@
>  > +                 GNU GENERAL PUBLIC LICENSE
>  > +                    Version 2, June 1991
>  > +
>  > + Copyright (C) 1989, 1991 Free Software Foundation, Inc.
>  > +     59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>  > + Everyone is permitted to copy and distribute verbatim copies
>  > + of this license document, but changing it is not allowed.
>  > +
>  > +                         Preamble
>  > +
>  > +  The licenses for most software are designed to take away your
>  > +freedom to share and change it.  By contrast, the GNU General Public
>  > +License is intended to guarantee your freedom to share and change free
>  > +software--to make sure the software is free for all its users.  This
>  > +General Public License applies to most of the Free Software
>  > +Foundation's software and to any other program whose authors commit to
>  > +using it.  (Some other Free Software Foundation software is covered by
>  > +the GNU Library General Public License instead.)  You can apply it to
>  > +your programs, too.
>  > +
>  > +  When we speak of free software, we are referring to freedom, not
>  > +price.  Our General Public Licenses are designed to make sure that you
>  > +have the freedom to distribute copies of free software (and charge for
>  > +this service if you wish), that you receive source code or can get it
>  > +if you want it, that you can change the software or use pieces of it
>  > +in new free programs; and that you know you can do these things.
>  > +
>  > +  To protect your rights, we need to make restrictions that forbid
>  > +anyone to deny you these rights or to ask you to surrender the rights.
>  > +These restrictions translate to certain responsibilities for you if you
>  > +distribute copies of the software, or if you modify it.
>  > +
>  > +  For example, if you distribute copies of such a program, whether
>  > +gratis or for a fee, you must give the recipients all the rights that
>  > +you have.  You must make sure that they, too, receive or can get the
>  > +source code.  And you must show them these terms so they know their
>  > +rights.
>  > +
>  > +  We protect your rights with two steps: (1) copyright the software, and
>  > +(2) offer you this license which gives you legal permission to copy,
>  > +distribute and/or modify the software.
>  > +
>  > +  Also, for each author's protection and ours, we want to make certain
>  > +that everyone understands that there is no warranty for this free
>  > +software.  If the software is modified by someone else and passed on, we
>  > +want its recipients to know that what they have is not the original, so
>  > +that any problems introduced by others will not reflect on the original
>  > +authors' reputations.
>  > +
>  > +  Finally, any free program is threatened constantly by software
>  > +patents.  We wish to avoid the danger that redistributors of a free
>  > +program will individually obtain patent licenses, in effect making the
>  > +program proprietary.  To prevent this, we have made it clear that any
>  > +patent must be licensed for everyone's free use or not licensed at all.
>  > +
>  > +  The precise terms and conditions for copying, distribution and
>  > +modification follow.
>  > +
>  > +                 GNU GENERAL PUBLIC LICENSE
>  > +   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
>  > +
>  > +  0. This License applies to any program or other work which contains
>  > +a notice placed by the copyright holder saying it may be distributed
>  > +under the terms of this General Public License.  The "Program", below,
>  > +refers to any such program or work, and a "work based on the Program"
>  > +means either the Program or any derivative work under copyright law:
>  > +that is to say, a work containing the Program or a portion of it,
>  > +either verbatim or with modifications and/or translated into another
>  > +language.  (Hereinafter, translation is included without limitation in
>  > +the term "modification".)  Each licensee is addressed as "you".
>  > +
>  > +Activities other than copying, distribution and modification are not
>  > +covered by this License; they are outside its scope.  The act of
>  > +running the Program is not restricted, and the output from the Program
>  > +is covered only if its contents constitute a work based on the
>  > +Program (independent of having been made by running the Program).
>  > +Whether that is true depends on what the Program does.
>  > +
>  > +  1. You may copy and distribute verbatim copies of the Program's
>  > +source code as you receive it, in any medium, provided that you
>  > +conspicuously and appropriately publish on each copy an appropriate
>  > +copyright notice and disclaimer of warranty; keep intact all the
>  > +notices that refer to this License and to the absence of any warranty;
>  > +and give any other recipients of the Program a copy of this License
>  > +along with the Program.
>  > +
>  > +You may charge a fee for the physical act of transferring a copy, and
>  > +you may at your option offer warranty protection in exchange for a fee.
>  > +
>  > +  2. You may modify your copy or copies of the Program or any portion
>  > +of it, thus forming a work based on the Program, and copy and
>  > +distribute such modifications or work under the terms of Section 1
>  > +above, provided that you also meet all of these conditions:
>  > +
>  > +    a) You must cause the modified files to carry prominent notices
>  > +    stating that you changed the files and the date of any change.
>  > +
>  > +    b) You must cause any work that you distribute or publish, that in
>  > +    whole or in part contains or is derived from the Program or any
>  > +    part thereof, to be licensed as a whole at no charge to all third
>  > +    parties under the terms of this License.
>  > +
>  > +    c) If the modified program normally reads commands interactively
>  > +    when run, you must cause it, when started running for such
>  > +    interactive use in the most ordinary way, to print or display an
>  > +    announcement including an appropriate copyright notice and a
>  > +    notice that there is no warranty (or else, saying that you provide
>  > +    a warranty) and that users may redistribute the program under
>  > +    these conditions, and telling the user how to view a copy of this
>  > +    License.  (Exception: if the Program itself is interactive but
>  > +    does not normally print such an announcement, your work based on
>  > +    the Program is not required to print an announcement.)
>  > +
>  > +These requirements apply to the modified work as a whole.  If
>  > +identifiable sections of that work are not derived from the Program,
>  > +and can be reasonably considered independent and separate works in
>  > +themselves, then this License, and its terms, do not apply to those
>  > +sections when you distribute them as separate works.  But when you
>  > +distribute the same sections as part of a whole which is a work based
>  > +on the Program, the distribution of the whole must be on the terms of
>  > +this License, whose permissions for other licensees extend to the
>  > +entire whole, and thus to each and every part regardless of who wrote it.
>  > +
>  > +Thus, it is not the intent of this section to claim rights or contest
>  > +your rights to work written entirely by you; rather, the intent is to
>  > +exercise the right to control the distribution of derivative or
>  > +collective works based on the Program.
>  > +
>  > +In addition, mere aggregation of another work not based on the Program
>  > +with the Program (or with a work based on the Program) on a volume of
>  > +a storage or distribution medium does not bring the other work under
>  > +the scope of this License.
>  > +
>  > +  3. You may copy and distribute the Program (or a work based on it,
>  > +under Section 2) in object code or executable form under the terms of
>  > +Sections 1 and 2 above provided that you also do one of the following:
>  > +
>  > +    a) Accompany it with the complete corresponding machine-readable
>  > +    source code, which must be distributed under the terms of Sections
>  > +    1 and 2 above on a medium customarily used for software interchange; or,
>  > +
>  > +    b) Accompany it with a written offer, valid for at least three
>  > +    years, to give any third party, for a charge no more than your
>  > +    cost of physically performing source distribution, a complete
>  > +    machine-readable copy of the corresponding source code, to be
>  > +    distributed under the terms of Sections 1 and 2 above on a medium
>  > +    customarily used for software interchange; or,
>  > +
>  > +    c) Accompany it with the information you received as to the offer
>  > +    to distribute corresponding source code.  (This alternative is
>  > +    allowed only for noncommercial distribution and only if you
>  > +    received the program in object code or executable form with such
>  > +    an offer, in accord with Subsection b above.)
>  > +
>  > +The source code for a work means the preferred form of the work for
>  > +making modifications to it.  For an executable work, complete source
>  > +code means all the source code for all modules it contains, plus any
>  > +associated interface definition files, plus the scripts used to
>  > +control compilation and installation of the executable.  However, as a
>  > +special exception, the source code distributed need not include
>  > +anything that is normally distributed (in either source or binary
>  > +form) with the major components (compiler, kernel, and so on) of the
>  > +operating system on which the executable runs, unless that component
>  > +itself accompanies the executable.
>  > +
>  > +If distribution of executable or object code is made by offering
>  > +access to copy from a designated place, then offering equivalent
>  > +access to copy the source code from the same place counts as
>  > +distribution of the source code, even though third parties are not
>  > +compelled to copy the source along with the object code.
>  > +
>  > +  4. You may not copy, modify, sublicense, or distribute the Program
>  > +except as expressly provided under this License.  Any attempt
>  > +otherwise to copy, modify, sublicense or distribute the Program is
>  > +void, and will automatically terminate your rights under this License.
>  > +However, parties who have received copies, or rights, from you under
>  > +this License will not have their licenses terminated so long as such
>  > +parties remain in full compliance.
>  > +
>  > +  5. You are not required to accept this License, since you have not
>  > +signed it.  However, nothing else grants you permission to modify or
>  > +distribute the Program or its derivative works.  These actions are
>  > +prohibited by law if you do not accept this License.  Therefore, by
>  > +modifying or distributing the Program (or any work based on the
>  > +Program), you indicate your acceptance of this License to do so, and
>  > +all its terms and conditions for copying, distributing or modifying
>  > +the Program or works based on it.
>  > +
>  > +  6. Each time you redistribute the Program (or any work based on the
>  > +Program), the recipient automatically receives a license from the
>  > +original licensor to copy, distribute or modify the Program subject to
>  > +these terms and conditions.  You may not impose any further
>  > +restrictions on the recipients' exercise of the rights granted herein.
>  > +You are not responsible for enforcing compliance by third parties to
>  > +this License.
>  > +
>  > +  7. If, as a consequence of a court judgment or allegation of patent
>  > +infringement or for any other reason (not limited to patent issues),
>  > +conditions are imposed on you (whether by court order, agreement or
>  > +otherwise) that contradict the conditions of this License, they do not
>  > +excuse you from the conditions of this License.  If you cannot
>  > +distribute so as to satisfy simultaneously your obligations under this
>  > +License and any other pertinent obligations, then as a consequence you
>  > +may not distribute the Program at all.  For example, if a patent
>  > +license would not permit royalty-free redistribution of the Program by
>  > +all those who receive copies directly or indirectly through you, then
>  > +the only way you could satisfy both it and this License would be to
>  > +refrain entirely from distribution of the Program.
>  > +
>  > +If any portion of this section is held invalid or unenforceable under
>  > +any particular circumstance, the balance of the section is intended to
>  > +apply and the section as a whole is intended to apply in other
>  > +circumstances.
>  > +
>  > +It is not the purpose of this section to induce you to infringe any
>  > +patents or other property right claims or to contest validity of any
>  > +such claims; this section has the sole purpose of protecting the
>  > +integrity of the free software distribution system, which is
>  > +implemented by public license practices.  Many people have made
>  > +generous contributions to the wide range of software distributed
>  > +through that system in reliance on consistent application of that
>  > +system; it is up to the author/donor to decide if he or she is willing
>  > +to distribute software through any other system and a licensee cannot
>  > +impose that choice.
>  > +
>  > +This section is intended to make thoroughly clear what is believed to
>  > +be a consequence of the rest of this License.
>  > +
>  > +  8. If the distribution and/or use of the Program is restricted in
>  > +certain countries either by patents or by copyrighted interfaces, the
>  > +original copyright holder who places the Program under this License
>  > +may add an explicit geographical distribution limitation excluding
>  > +those countries, so that distribution is permitted only in or among
>  > +countries not thus excluded.  In such case, this License incorporates
>  > +the limitation as if written in the body of this License.
>  > +
>  > +  9. The Free Software Foundation may publish revised and/or new versions
>  > +of the General Public License from time to time.  Such new versions will
>  > +be similar in spirit to the present version, but may differ in detail to
>  > +address new problems or concerns.
>  > +
>  > +Each version is given a distinguishing version number.  If the Program
>  > +specifies a version number of this License which applies to it and "any
>  > +later version", you have the option of following the terms and conditions
>  > +either of that version or of any later version published by the Free
>  > +Software Foundation.  If the Program does not specify a version number of
>  > +this License, you may choose any version ever published by the Free Software
>  > +Foundation.
>  > +
>  > +  10. If you wish to incorporate parts of the Program into other free
>  > +programs whose distribution conditions are different, write to the author
>  > +to ask for permission.  For software which is copyrighted by the Free
>  > +Software Foundation, write to the Free Software Foundation; we sometimes
>  > +make exceptions for this.  Our decision will be guided by the two goals
>  > +of preserving the free status of all derivatives of our free software and
>  > +of promoting the sharing and reuse of software generally.
>  > +
>  > +                         NO WARRANTY
>  > +
>  > +  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
>  > +FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
>  > +OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
>  > +PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
>  > +OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
>  > +MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
>  > +TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
>  > +PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
>  > +REPAIR OR CORRECTION.
>  > +
>  > +  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
>  > +WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
>  > +REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
>  > +INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
>  > +OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
>  > +TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
>  > +YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
>  > +PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
>  > +POSSIBILITY OF SUCH DAMAGES.
>  > +
>  > +                  END OF TERMS AND CONDITIONS
>  > +
>  > +         How to Apply These Terms to Your New Programs
>  > +
>  > +  If you develop a new program, and you want it to be of the greatest
>  > +possible use to the public, the best way to achieve this is to make it
>  > +free software which everyone can redistribute and change under these terms.
>  > +
>  > +  To do so, attach the following notices to the program.  It is safest
>  > +to attach them to the start of each source file to most effectively
>  > +convey the exclusion of warranty; and each file should have at least
>  > +the "copyright" line and a pointer to where the full notice is found.
>  > +
>  > +    <one line to give the program's name and a brief idea of what it does.>
>  > +    Copyright (C) <year>  <name of author>
>  > +
>  > +    This program is free software; you can redistribute it and/or modify
>  > +    it under the terms of the GNU General Public License as published by
>  > +    the Free Software Foundation; either version 2 of the License, or
>  > +    (at your option) any later version.
>  > +
>  > +    This program is distributed in the hope that it will be useful,
>  > +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>  > +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  > +    GNU General Public License for more details.
>  > +
>  > +    You should have received a copy of the GNU General Public License
>  > +    along with this program; if not, write to the Free Software
>  > +    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>  > +
>  > +
>  > +Also add information on how to contact you by electronic and paper mail.
>  > +
>  > +If the program is interactive, make it output a short notice like this
>  > +when it starts in an interactive mode:
>  > +
>  > +    Gnomovision version 69, Copyright (C) year  name of author
>  > +    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
>  > +    This is free software, and you are welcome to redistribute it
>  > +    under certain conditions; type `show c' for details.
>  > +
>  > +The hypothetical commands `show w' and `show c' should show the appropriate
>  > +parts of the General Public License.  Of course, the commands you use may
>  > +be called something other than `show w' and `show c'; they could even be
>  > +mouse-clicks or menu items--whatever suits your program.
>  > +
>  > +You should also get your employer (if you work as a programmer) or your
>  > +school, if any, to sign a "copyright disclaimer" for the program, if
>  > +necessary.  Here is a sample; alter the names:
>  > +
>  > +  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
>  > +  `Gnomovision' (which makes passes at compilers) written by James Hacker.
>  > +
>  > +  <signature of Ty Coon>, 1 April 1989
>  > +  Ty Coon, President of Vice
>  > +
>  > +This General Public License does not permit incorporating your program into
>  > +proprietary programs.  If your program is a subroutine library, you may
>  > +consider it more useful to permit linking proprietary applications with the
>  > +library.  If this is what you want to do, use the GNU Library General
>  > +Public License instead of this License.
>  > diff --git a/drivers/net/wireless/mrv8k/Kconfig b/drivers/net/wireless/mrv8k/Kconfig
>  > new file mode 100644
>  > index 0000000..35f1bd6
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/Kconfig
>  > @@ -0,0 +1,19 @@
>  > +config MRV8K
>  > +     tristate "Marvell 88w8335 Libertas PCMCIA-wireless support"
>  > +     depends on PCMCIA && MAC80211 && WLAN_80211 && EXPERIMENTAL
>  > +     select FW_LOADER
>  > +     ---help---
>  > +       This is an experimental driver for the Marvell 88w8335 Libertas wireless
>  > +       chip, present in many PCMCIA-wireless adapters.
>  > +
>  > +       Device firmware is required alongside this driver. You can download
>  > +       the firmware cutter from http://www.saillard.org/linux/mrv8k/files/
>  > +
>  > +config MRV8K_DEBUG
>  > +     bool "Marvell 88w8335 Libertas debugging"
>  > +     depends on MRV8K
>  > +     ---help---
>  > +       MRV8K debugging messages. Choosing Y will result in additional debug
>  > +       messages being saved to your kernel logs, which may help debug any
>  > +       problems.
>  > +
>  > diff --git a/drivers/net/wireless/mrv8k/Makefile b/drivers/net/wireless/mrv8k/Makefile
>  > new file mode 100644
>  > index 0000000..054977d
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/Makefile
>  > @@ -0,0 +1,11 @@
>  > +obj-$(CONFIG_MRV8K) += mrv8.o
>  > +
>  > +
>  > +
>  > +
>  > +
>  > +
>  > +ifeq ($(CONFIG_MRV8K_DEBUG),y)
>  > +EXTRA_CFLAGS += -DDEBUG
>  > +endif
>  > +
>  > diff --git a/drivers/net/wireless/mrv8k/README b/drivers/net/wireless/mrv8k/README
>  > new file mode 100644
>  > index 0000000..f964115
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/README
>  > @@ -0,0 +1,31 @@
>  > +Linux driver for Marvell Libertas PCI wireless chipset
>  > +Copyright(c) Andrea Merello, 2007
>  > +Released unter the terms of GPL license
>  > +
>  > +--------------------------------------------------------------------
>  > +Currently this driver is under development and can't be considered
>  > +finished.
>  > +It's currently using the d80211 stack, so you will need a kernel from
>  > +wireless-dev git tree.
>  > +As the Marvell chip can do MAC handling (at least partially) in HW it
>  > +is possible I will change, and d80211 stack will become unnecessary.
>  > +For now FullMAC implementation in firmware is not used.
>  > +
>  > +For now the driver supports only BSS STA mode and monitor mode.
>  > +Scan, sw encryption and MAC address changing should also work.
>  > +
>  > +Monitor mode is mostly functional, but not perfect, as FW filters certain
>  > +packets. It is possible to see frames sent to all MAC addresses in any BSS
>  > +on the selected channel, but certain particular frames, like ACKs are
>  > +not passed by the card to upper layer. It is unsure if there is any way
>  > +to obtain this.
>  > +
>  > +IBSS and AP mode are currently disabled.
>  > +
>  > +----IMPORTANT NOTE----
>  > +For using this driver you will need marvell firmware.
>  > +You can obtain it using the utility for firmware extracting published
>  > +my Luc Saillard on his website or using the firmware package for BSD
>  > +malo driver.
>  > +The driver will load the firmware while loading the module (this may
>  > +change in future) and it is normal it will take several seconds.
>  > diff --git a/drivers/net/wireless/mrv8k/TODO b/drivers/net/wireless/mrv8k/TODO
>  > new file mode 100644
>  > index 0000000..28ee8dc
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/TODO
>  > @@ -0,0 +1,5 @@
>  > +Check for the RX reschedule
>  > +Check for TX skb free ------ should be ok
>  > +Check for SSI and NF
>  > +Check for rates and txpower
>  > +
>  > diff --git a/drivers/net/wireless/mrv8k/mrv8.c b/drivers/net/wireless/mrv8k/mrv8.c
>  > new file mode 100644
>  > index 0000000..3695c19
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/mrv8.c
>  > @@ -0,0 +1,1668 @@
>  > +/*
>  > +     d80211 Marvell Libertas PCI driver
>  > +
>  > +     Copyright (c) 2007 Andrea Merello <andreamrl@tiscali.it>
>  > +
>  > +     Based on existent mrv8k linux alpha driver
>  > +     Copyright (c) 2005 Luc Saillard <luc@saillard.org>
>  > +
>  > +     Based on BSD malo driver
>  > +     Copyright (c) 2006 Claudio Jeker <claudio@openbsd.org>
>  > +     Copyright (c) 2006 Marcus Glocker <mglocker@openbsd.org>
>  > +     (no code has been copyed. Hw programming methods
>  > +     magic values, and card specific programming details
>  > +     had been looked at)
>  > +
>  > +     This program is free software; you can redistribute it and/or modify
>  > +     it under the terms of the GNU General Public License as published by
>  > +     the Free Software Foundation; either version 2 of the License, or
>  > +     (at your option) any later version.
>  > +
>  > +     This program is distributed in the hope that it will be useful,
>  > +     but WITHOUT ANY WARRANTY; without even the implied warranty of
>  > +     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  > +     GNU General Public License for more details.
>  > +
>  > +     You should have received a copy of the GNU General Public License
>  > +     along with this program; see the file COPYING.  If not, write to
>  > +     the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
>  > +     Boston, MA 02110-1301, USA.
>  > +
>  > +*/
>  > +
>  > +#include <linux/firmware.h>
>  > +#include <linux/init.h>
>  > +#include <linux/delay.h>
>  > +#include <linux/pci.h>
>  > +#include <linux/etherdevice.h>
>  > +#include <asm/semaphore.h>
>  > +#include <net/mac80211.h>
>  > +#include <net/ieee80211_radiotap.h>
>  > +
>  > +#include "mrv8.h"
>  > +
>  > +MODULE_AUTHOR(DRV_COPYRIGHT);
>  > +MODULE_DESCRIPTION(DRV_DESCRIPTION);
>  > +MODULE_VERSION(DRV_VERSION);
>  > +MODULE_LICENSE("GPL");
>  > +
>  > +#if !defined(MAC_ARG)
>  > +#define MAC_ARG(x) (\
>  > +((u8 *)(x))[0], ((u8 *)(x))[1], \
>  > +((u8 *)(x))[2], ((u8 *)(x))[3], \
>  > +((u8 *)(x))[4], ((u8 *)(x))[5])
>  > +#endif
>  > +
>  > +static struct pci_device_id mrv_pci_tbl[] = {
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA4, 0x11AB, 0, 0, WL3563 },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA5, 0x16AB, 0, 0, WL3563 },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA6, 0x16AB, 0, 0, WL3563 },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA7, 0x16AB, 0, 0, WL3563 },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x138f, 0x1043, 0, 0, WL138G },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x128f, 0x1043, 0, 0, WL138G },
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x108f, 0x1043, 0, 0, WL138G },
>  > +     /* NETGEAR WG311v3 802.11g Wireless PCI Adapter */
>  > +     {PCI_VENDOR_ID_MARVELL, 0x1faa, PCI_ANY_ID, PCI_ANY_ID, 0x6b00, 0x1385, W8335},
>  > +     {PCI_VENDOR_ID_MARVELL, 0x1faa, PCI_ANY_ID, PCI_ANY_ID, 0, 0, W8335},
>  > +     {PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, PCI_ANY_ID, PCI_ANY_ID, 0, 0, WLGENERIC },
>  > +     {0,}
>  > +};
>  > +
>  > +static void mrv_deinit_cmd(struct mrv_priv *priv)
>  > +{
>  > +     if (priv->cmd_virt)
>  > +             pci_free_consistent(priv->pdev,
>  > +                     MRV_CMD_PKT_SIZE,
>  > +                     priv->cmd_virt, priv->cmd_dma);
>  > +
>  > +     if (priv->magic_virt)
>  > +             pci_free_consistent(priv->pdev, 4,
>  > +                     priv->magic_virt, priv->magic_dma);
>  > +}
>  > +
>  > +static void mrv_free_rx_ring(struct mrv_priv *priv)
>  > +{
>  > +     int i;
>  > +     for (i = 0; i < MRV_RX_DESC_NUM; i++) {
>  > +             dev_kfree_skb(priv->rx_skb[i]);
>  > +             pci_free_consistent(priv->pdev,
>  > +                     sizeof(struct mrv_rx_descriptor),
>  > +                     priv->rx_ring_virt[i],
>  > +                     priv->rx_ring_dma[i]);
>  > +     }
>  > +
>  > +}
>  > +
>  > +static void mrv_free_tx_ring(struct mrv_priv *priv)
>  > +{
>  > +     int i, j;
>  > +     for (i = 0; i < MRV_TX_DESC_NUM; i++)
>  > +             pci_free_consistent(priv->pdev,
>  > +                     sizeof(struct mrv_tx_descriptor),
>  > +                     priv->tx_ring_virt[i],
>  > +                     priv->tx_ring_dma[i]);
>  > +
>  > +     for (i = 0; i < priv->tx_pending; i++) {
>  > +             j = priv->tx_r_idx;
>  > +             dev_kfree_skb(priv->tx_skb[j]);
>  > +             if (j == MRV_TX_DESC_NUM - 1)
>  > +                     j = 0;
>  > +             else
>  > +                     j++;
>  > +     }
>  > +}
>  > +
>  > +static int mrv_init_cmd(struct mrv_priv *priv)
>  > +{
>  > +     void *v;
>  > +     dma_addr_t p;
>  > +     v = pci_alloc_consistent(priv->pdev, MRV_CMD_PKT_SIZE, &p);
>  > +     priv->cmd_virt = v;
>  > +
>  > +     if (v == NULL) {
>  > +             printk(KERN_ERR"Can't allocate CMD memory\n");
>  > +             return -ENOMEM;
>  > +     }
>  > +
>  > +     priv->cmd_dma = p;
>  > +     v = pci_alloc_consistent(priv->pdev, 4, &p);
>  > +     priv->magic_virt = v;
>  > +
>  > +     if (v == NULL) {
>  > +             printk(KERN_ERR"Can't allocate MAGIC memory\n");
>  > +             return -ENOMEM;
>  > +     }
>  > +
>  > +     priv->magic_dma = p;
>  > +     *priv->magic_virt = cpu_to_le32(MRV_CMD_MAGIC);
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void _mrv_send_cmd(struct mrv_priv *priv, u32 addr)
>  > +{
>  > +  /* printk(KERN_ERR"_mrv_send_cmd\n");*/
>  > +     wmb();
>  > +     mrv_reg_write32(priv, MRV_REG_CMD_PTR,  addr);
>  > +     mrv_reg_mb(priv);
>  > +     mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, 2);
>  > +     mrv_reg_mb(priv);
>  > +}
>  > +
>  > +static inline void mrv_send_cmd(struct mrv_priv *priv)
>  > +{
>  > +  /* printk(KERN_ERR"mrv_send_cmd\n");*/
>  > +     _mrv_send_cmd(priv, priv->cmd_dma);
>  > +}
>  > +
>  > +static int mrv_send_cmd_sync(struct mrv_priv *priv)
>  > +{
>  > +     int err;
>  > +
>  > +     /*      printk(KERN_ERR"mrv_send_cmd_sync\n");*/
>  > +     down(&priv->cmd_sem);
>  > +     err = 0;
>  > +     priv->cmd_status = 0x10000;
>  > +     mrv_send_cmd(priv);
>  > +
>  > +     /*      printk(KERN_ERR"mrv_send_cmd_time\n");*/
>  > +     wait_event_interruptible_timeout(priv->wait_command_queue,
>  > +                                      (priv->cmd_status != 0x10000), 500);
>  > +     /*      printk(KERN_ERR"mrv_send_cmd_timeout\n");*/
>  > +
>  > +     if (priv->cmd_status == 0x10000) {
>  > +             printk(KERN_ERR"Command timeout\n");
>  > +             err = -1;
>  > +     } else if (priv->cmd_status == 3) {
>  > +             printk(KERN_WARNING"Command deferred!\n");
>  > +             err = 0;
>  > +     } else if (priv->cmd_status != 0) {
>  > +             printk(KERN_ERR"Command failed with status %x\n", priv->cmd_status);
>  > +             err = -1;
>  > +     } else {
>  > +       printk(KERN_ERR"status %x\n", priv->cmd_status);
>  > +     }
>  > +
>  > +     up(&priv->cmd_sem);
>  > +
>  > +     return err;
>  > +}
>  > +
>  > +static inline struct mrv_cmd_hdr *mrv_cmd(struct mrv_priv *priv,
>  > +                                       int cmd,
>  > +                                       int len,
>  > +                                       int status,
>  > +                                       int sq)
>  > +{
>  > +     struct mrv_cmd_hdr *ret;
>  > +
>  > +     /*      printk(KERN_ERR"mrv_cmd %x %x %x %x\n", cmd, len, status, sq);*/
>  > +
>  > +     ret = (struct mrv_cmd_hdr *)priv->cmd_virt;
>  > +     ret->type = cpu_to_le16(cmd);
>  > +     ret->len = cpu_to_le16(len);
>  > +     ret->status = cpu_to_le16(status);
>  > +     ret->sq = cpu_to_le16(sq);
>  > +     return ret;
>  > +}
>  > +
>  > +static int mrv_upload_fw(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     u8 *cmd_data;
>  > +     const struct firmware *img = NULL;
>  > +     int i, j, sq, err;
>  > +
>  > +     err = request_firmware(&img, FW_BOOT_FILENAME, &priv->pdev->dev);
>  > +     if (err < 0) {
>  > +             printk(KERN_ERR"request_firmware for boot img failed: Reason %d\n", err);
>  > +             return err;
>  > +     }
>  > +
>  > +     mrv_reg_write32(priv, MRV_REG_STATUS, 0);
>  > +     mrv_reg_mb(priv);
>  > +     mrv_mem_write16(priv, MRV_MEM_CMD_BOOT, MRV_CMD_FW);
>  > +     mrv_mem_write16(priv, MRV_MEM_CMD_BOOT+2, img->size);
>  > +     mrv_mem_write32(priv, MRV_MEM_CMD_BOOT+4, 0);
>  > +
>  > +     for (i = 0; i < img->size; i++)
>  > +             mrv_mem_write8(priv, MRV_MEM_CMD_BOOT+8+i, (img->data)[i]);
>  > +
>  > +     release_firmware(img);
>  > +
>  > +     _mrv_send_cmd(priv, MRV_HWMEM_CMD_BOOT);
>  > +
>  > +     for (i = 0; i < 500; i++) {
>  > +             if (mrv_reg_read32(priv, MRV_REG_STATUS) == 0x5)
>  > +             mdelay(1);
>  > +                     break;
>  > +     }
>  > +     if (i == 10) {
>  > +             printk(KERN_ERR"Timeout while loading boot fw \n");
>  > +             return -1;
>  > +     }
>  > +     /*printk(KERN_INFO"Bootstrap loaded OK, jumping in..\n");*/
>  > +     mrv_mem_write16(priv, MRV_MEM_CMD_BOOT, MRV_CMD_FW);
>  > +     mrv_mem_write16(priv, MRV_MEM_CMD_BOOT+2, 0);
>  > +     mrv_mem_write32(priv, MRV_MEM_CMD_BOOT+4, 0);
>  > +
>  > +     _mrv_send_cmd(priv, MRV_HWMEM_CMD_BOOT);
>  > +
>  > +     /* the boot code is stupid enought that it does not report any status when it
>  > +      * loads correctly and become alive. Wait 1 second..*/
>  > +     msleep(1000);
>  > +
>  > +     err = request_firmware(&img, FW_FIRMWARE_FILENAME, &priv->pdev->dev);
>  > +     if (err < 0) {
>  > +             printk(KERN_ERR"request_firmware for fw img2 failed: Reason %d\n", err);
>  > +             return err;
>  > +     }
>  > +
>  > +     sq = 1;
>  > +     for (i = 0; (i+256) < img->size; i += 256) {
>  > +             mrv_reg_write32(priv, MRV_REG_STATUS, 0);
>  > +             mrv_reg_mb(priv);
>  > +             cmd = mrv_cmd(priv, MRV_CMD_FW, 256, 0, sq++);
>  > +             cmd_data = MRV_CMD_PAYLOAD(cmd) ;
>  > +             memcpy(cmd_data, img->data + i, 256);
>  > +             mrv_send_cmd(priv);
>  > +             for (j = 0; j < 500; j++) {
>  > +                     if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
>  > +                       break;
>  > +                     mdelay(1);
>  > +             }
>  > +             if (j == 500) {
>  > +                     printk(KERN_ERR"Boot FW has failed to transfer real FW\n");
>  > +                     return -2;
>  > +             }
>  > +     }
>  > +
>  > +     if (i < img->size) {
>  > +             mrv_reg_write32(priv, MRV_REG_STATUS, 0);
>  > +             mrv_reg_mb(priv);
>  > +             cmd = mrv_cmd(priv, MRV_CMD_FW, img->size - i, 0, sq++);
>  > +             cmd_data = MRV_CMD_PAYLOAD(cmd) ;
>  > +             memcpy(cmd_data, img->data + i, img->size - i);
>  > +             mrv_send_cmd(priv);
>  > +             for (j = 0; j < 500; j++) {
>  > +                     if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
>  > +                       break;
>  > +                     mdelay(1);
>  > +             }
>  > +             if (j == 500) {
>  > +                     printk(KERN_ERR"Boot FW has failed to transfer last real FW chunk\n");
>  > +                     return -2;
>  > +             }
>  > +     }
>  > +
>  > +     release_firmware(img);
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_FW, 0, 0, sq);
>  > +
>  > +     mrv_send_cmd(priv);
>  > +     msleep(100);
>  > +
>  > +     for (i = 0; i < 200; i++) {
>  > +             mrv_reg_write32(priv, MRV_REG_CMD_PTR, 0x5a);
>  > +             mrv_reg_mb(priv);
>  > +             if (mrv_reg_read32(priv, MRV_REG_STATUS) == MRV_FW_SIGNATURE)
>  > +                     break;
>  > +             mdelay(10);
>  > +     }
>  > +
>  > +     if (i == 200) {
>  > +             printk(KERN_ERR"FW is not alive or returned error %x \n",
>  > +                     mrv_reg_read32(priv, MRV_REG_STATUS));
>  > +             return -1;
>  > +     }
>  > +
>  > +     priv->fw_load = 1;
>  > +     printk(KERN_INFO"Firmware for mrv loaded successfully\n");
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_int_enable(struct mrv_priv *priv)
>  > +{
>  > +     mrv_reg_write32(priv, MRV_REG_INTA_MASK, MRV_INTA_MASK);
>  > +     mrv_reg_write32(priv, MRV_REG_INTB_MASK, MRV_INTB_MASK);
>  > +     mrv_reg_mb(priv);
>  > +}
>  > +
>  > +static void mrv_int_disable(struct mrv_priv *priv)
>  > +{
>  > +     mrv_reg_write32(priv, MRV_REG_INTA_MASK, 0);
>  > +     mrv_reg_write32(priv, MRV_REG_INTB_MASK, 0);
>  > +     mrv_reg_mb(priv);
>  > +}
>  > +
>  > +static int mrv_tx(struct ieee80211_hw *dev,
>  > +               struct sk_buff *skb,
>  > +               struct ieee80211_tx_control *control)
>  > +{
>  > +     struct ieee80211_hdr *hdr;
>  > +     struct mrv_tx_descriptor *txd;
>  > +     unsigned long flags;
>  > +     struct mrv_priv *priv = dev->priv;
>  > +
>  > +     spin_lock_irqsave(&priv->tx_lock, flags);
>  > +
>  > +     if (skb->len < sizeof(struct ieee80211_hdr)) {
>  > +             spin_unlock_irqrestore(&priv->tx_lock, flags);
>  > +             return NETDEV_TX_OK;
>  > +     }
>  > +
>  > +     if (priv->tx_pending >= (MRV_TX_DESC_NUM-2)) {
>  > +             ieee80211_stop_queue(dev, 0);
>  > +     }
>  > +
>  > +     if (skb_headroom(skb) < dev->extra_tx_headroom) {
>  > +             if (pskb_expand_head(skb, dev->extra_tx_headroom, 0, GFP_ATOMIC)) {
>  > +                     printk(KERN_ERR "failed to allocate room for TX "
>  > +                            "header\n");
>  > +                     kfree_skb(skb);
>  > +                     spin_unlock_irqrestore(&priv->tx_lock, flags);
>  > +                     return -ENOMEM;
>  > +             }
>  > +     }
>  > +
>  > +     priv->tx_pending++;
>  > +     priv->tx_skb[priv->tx_w_idx] = skb;
>  > +     txd = priv->tx_ring_virt[priv->tx_w_idx];
>  > +
>  > +     if (priv->tx_w_idx == MRV_TX_DESC_NUM-1)
>  > +             priv->tx_w_idx = 0;
>  > +     else
>  > +             priv->tx_w_idx++;
>  > +
>  > +     memcpy(txd->dest_addr,
>  > +             ieee80211_get_DA((struct ieee80211_hdr *)skb->data), 6);
>  > +
>  > +     skb_push(skb, dev->extra_tx_headroom);
>  > +
>  > +     *((u16 *)skb->data) = cpu_to_le16(skb->len) - 32;
>  > +
>  > +     memcpy(skb->data+2, skb->data+8, 24); /* move 80211 header */
>  > +     hdr = (struct ieee80211_hdr *)skb->data + 2;
>  > +     memcpy(skb->data+2+24, &(hdr->addr4), 6); /* copy addr4 */
>  > +
>  > +     txd->len = cpu_to_le16(skb->len);
>  > +
>  > +     txd->dma_addr = cpu_to_le32(pci_map_single(priv->pdev,
>  > +                     skb->data, skb->len, PCI_DMA_TODEVICE));
>  > +
>  > +     txd->priority = control->queue;
>  > +     /*txd->rate = control->tx_rate;*/
>  > +
>  > +     txd->status = cpu_to_le16(1);
>  > +     txd->fwowner = cpu_to_le16(0x8000);
>  > +     wmb();
>  > +     mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, 1);
>  > +     mrv_reg_mb(priv);
>  > +
>  > +     spin_unlock_irqrestore(&priv->tx_lock, flags);
>  > +
>  > +     return NETDEV_TX_OK;
>  > +}
>  > +
>  > +static void mrv_tx_cb_tasklet(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_tx_descriptor *txd;
>  > +     int status;
>  > +     unsigned long flags;
>  > +     struct ieee80211_tx_status tx_status = { {0} };
>  > +
>  > +     spin_lock_irqsave(&priv->tx_lock, flags);
>  > +
>  > +     while (priv->tx_r_idx != priv->tx_w_idx) {
>  > +             txd = priv->tx_ring_virt[priv->tx_r_idx];
>  > +
>  > +             if (le16_to_cpu(txd->fwowner) & 0x8000)
>  > +                     break;
>  > +
>  > +             status = le16_to_cpu(txd->status) & 0x1;
>  > +             if (status == 0)
>  > +               tx_status.excessive_retries = 1;
>  > +             tx_status.queue_number = txd->priority;
>  > +
>  > +             pci_unmap_single(priv->pdev, txd->dma_addr,
>  > +                     priv->tx_skb[priv->tx_r_idx]->len, PCI_DMA_TODEVICE);
>  > +
>  > +             ieee80211_tx_status_irqsafe(priv->dev,
>  > +                     priv->tx_skb[priv->tx_r_idx], &tx_status);
>  > +
>  > +             priv->tx_pending--;
>  > +
>  > +             if (priv->tx_pending == MRV_TX_DESC_NUM-2)
>  > +                     ieee80211_wake_queue(priv->dev, 0);
>  > +
>  > +             if (priv->tx_r_idx == MRV_TX_DESC_NUM-1)
>  > +                     priv->tx_r_idx = 0;
>  > +             else
>  > +                     priv->tx_r_idx++;
>  > +     }
>  > +
>  > +     spin_unlock_irqrestore(&priv->tx_lock, flags);
>  > +}
>  > +
>  > +static void mrv_rx_tasklet(struct mrv_priv *priv)
>  > +{
>  > +     int len, count = 0;
>  > +     struct ieee80211_rx_status rx_status = {0};
>  > +     struct mrv_rx_descriptor *rxd;
>  > +     struct sk_buff *skb;
>  > +
>  > +     for (count = 0; count < MRV_MAX_RX_INT; count++) {
>  > +             rxd = priv->rx_ring_virt[priv->rx_idx];
>  > +             skb = priv->rx_skb[priv->rx_idx];
>  > +
>  > +             if ((rxd->drvowner & 0x80) == 0)
>  > +                     break;
>  > +             if (mrv_mem_read32(priv, priv->RxHwDmaR) ==
>  > +                     mrv_mem_read32(priv, priv->RxHwDmaW))
>  > +                     break;
>  > +
>  > +             len = le16_to_cpu(rxd->datalen);
>  > +
>  > +             if (len > 3) {
>  > +
>  > +                     rx_status.ssi = rxd->rssi;
>  > +                     /*              rx_status.antenna = (hdr->signal >> 7) & 1;
>  > +                     rx_status.signal = quality;
>  > +                     rx_status.rate = rxd->rate;
>  > +                     rx_status.freq = mrv_channels[rxd->chan -1].freq;
>  > +                     rx_status.channel = rxd->chan;
>  > +                     rx_status.phymode = priv->dev->conf.phymode;
>  > +                     rx_status.mactime = le64_to_cpu(hdr->mac_time);*/
>  > +
>  > +                     pci_unmap_single(priv->pdev, rxd->dma_data,
>  > +                             MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE);
>  > +
>  > +                     /*This is the madness of how firmware reworks packets...
>  > +                     * So we have to cut out this damn garbage the firmware
>  > +                     * puts at the beginning and in the middle of packets.....
>  > +                     */
>  > +                     skb_put(skb, len);
>  > +                     skb_pull(skb, 2);
>  > +
>  > +                     if (skb->len > 30) {
>  > +                             memcpy(skb->data + 24, skb->data + 30, skb->len - 6);
>  > +                             skb_trim(skb, skb->len - 6);
>  > +                     }
>  > +                     /*if (skb->len < 50) {
>  > +                       printk("\n.........");
>  > +                       for(i=0;i<skb->len;i++)
>  > +                       printk("%x ", skb->data[i]);
>  > +                       }
>  > +                     */
>  > +                     ieee80211_rx_irqsafe(priv->dev, skb, &rx_status);
>  > +
>  > +                     /*TODO check for failure */
>  > +                     skb = dev_alloc_skb(MRV_RX_PAYLOAD_LEN);
>  > +                     priv->rx_skb[priv->rx_idx] = skb;
>  > +
>  > +                     rxd->dma_data = cpu_to_le32(pci_map_single(priv->pdev,
>  > +                                     skb->data, MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE));
>  > +             }
>  > +
>  > +             rxd->drvowner = 0;
>  > +
>  > +             if (priv->rx_idx == MRV_RX_DESC_NUM-1)
>  > +                     priv->rx_idx = 0;
>  > +             else
>  > +                     priv->rx_idx++;
>  > +             wmb();
>  > +             mrv_mem_write32(priv, priv->RxHwDmaR, priv->rx_ring_dma[priv->rx_idx]);
>  > +     }
>  > +
>  > +     /*rxd = priv->rx_ring_virt[priv->rx_idx];
>  > +       if (priv->up && ((rxd->drvowner & 0x80)!= 0))
>  > +       tasklet_schedule(&priv->mrv_rx_tasklet);*/
>  > +}
>  > +
>  > +irqreturn_t mrv_interrupt(int irq, void *data)
>  > +{
>  > +     struct mrv_priv *priv = (struct mrv_priv *) data;
>  > +     struct mrv_cmd_hdr *cmd;
>  > +     unsigned int status;
>  > +     unsigned int flags;
>  > +
>  > +     spin_lock_irqsave(&priv->irq_th_lock, flags);
>  > +
>  > +     if (!priv->fw_load) {
>  > +             spin_unlock_irqrestore(&priv->irq_th_lock, flags);
>  > +             return IRQ_NONE;
>  > +     }
>  > +
>  > +     mrv_int_disable(priv);
>  > +
>  > +     status = mrv_reg_read32(priv, MRV_REG_ISR);
>  > +
>  > +     if (status == 0xFFFFFFFF) {
>  > +             spin_unlock_irqrestore(&priv->irq_th_lock, flags);
>  > +             mrv_int_enable(priv);
>  > +             return IRQ_NONE;
>  > +
>  > +     }
>  > +     status &= MRV_INTA_MASK;
>  > +
>  > +     if (status == 0) {
>  > +             spin_unlock_irqrestore(&priv->irq_th_lock, flags);
>  > +             mrv_int_enable(priv);
>  > +             return IRQ_NONE;
>  > +     }
>  > +
>  > +     if (status & 0x4) {
>  > +             cmd = (struct mrv_cmd_hdr *)priv->cmd_virt;
>  > +             priv->cmd_status = le16_to_cpu(cmd->status);
>  > +             wake_up_interruptible(&priv->wait_command_queue);
>  > +     }
>  > +
>  > +     if (status & 0x2)
>  > +             tasklet_schedule(&priv->mrv_rx_tasklet);
>  > +
>  > +     if (status & 0x1)
>  > +             tasklet_schedule(&priv->mrv_tx_cb_tasklet);
>  > +
>  > +     status = status & ~(0x4|0x2|0x1);
>  > +
>  > +     mrv_reg_write32(priv, MRV_REG_ISR, status);
>  > +     mrv_reg_mb(priv);
>  > +
>  > +     mrv_int_enable(priv);
>  > +     spin_unlock_irqrestore(&priv->irq_th_lock, flags);
>  > +     return IRQ_HANDLED;
>  > +}
>  > +
>  > +/*
>  > +static void dump_reg(struct mrv_priv *priv)
>  > +{
>  > +//
>  > +      0 HIU host interf 0c pci interf
>  > +      2 CIU
>  > +      4 SQRAM
>  > +      6 SDRAM
>  > +      8 FEMAC
>  > +      a WLMAC. a0 WLMACTXCONFIG ,a2 WLMACRXCONFIG
>  > +      c LBU. c2 eeprom, c4 rf, c6 BB, c8 lsbu
>  > +      d GPIO. d8, pwrmgmt
>  > +      e DMA
>  > +     //
>  > +     int i;
>  > +     for (i = 0; i < 0xfff; i++) {
>  > +             if ( i % 18 == 0) printk("\n");
>  > +             printk("%4x= %2x, ", i, mrv_reg_read8(priv, i));
>  > +     }
>  > +     }*/
>  > +
>  > +static int mrv_hw_start(struct mrv_priv *priv)
>  > +{
>  > +     int err;
>  > +
>  > +     err = request_irq(priv->pdev->irq, &mrv_interrupt, IRQF_SHARED,
>  > +                       DRV_NAME, priv);
>  > +     if (err) {
>  > +             printk(KERN_ERR"Error calling request_irq: %d.\n",
>  > +                    priv->pdev->irq);
>  > +             return err;
>  > +     }
>  > +
>  > +     mrv_reg_read32(priv, MRV_REG_ISR);
>  > +     mrv_reg_write32(priv, MRV_REG_ISR, 0);
>  > +     mrv_reg_write32(priv, 0xc20, 0x800f);
>  > +     mrv_reg_write32(priv, 0xc24, 0x800f);
>  > +     mrv_int_disable(priv);
>  > +
>  > +     err = mrv_upload_fw(priv);
>  > +
>  > +     if (err) {
>  > +             free_irq(priv->pdev->irq, priv);
>  > +             return err;
>  > +     }
>  > +
>  > +     mrv_int_enable(priv);
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_hw_halt(struct mrv_priv *priv)
>  > +{
>  > +     mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, (1 << 15));
>  > +     mrv_reg_mb(priv);
>  > +     mrv_int_disable(priv);
>  > +     free_irq(priv->pdev->irq, priv);
>  > +}
>  > +
>  > +static int mrv_set_antenna(struct mrv_priv *priv, int rtx, int param)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_antenna *data;
>  > +
>  > +     /*printk(KERN_ERR"mrv_set_Antenna\n");*/
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_ANTENNA,
>  > +             MRV_CMD_SET_ANTENNA_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_antenna *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->rtx = cpu_to_le16(rtx);
>  > +     data->param = cpu_to_le16(param);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set antenna\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_txpower(struct mrv_priv *priv, int param)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_txpower *data;
>  > +
>  > +     /*printk(KERN_ERR"mrv_set_txpower\n");*/
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_TXPOWER,
>  > +             MRV_CMD_SET_TXPOWER_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_txpower *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->txpower = cpu_to_le16(param);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set txpower\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_radio(struct mrv_priv *priv, int enable, int preamble)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_radio *data;
>  > +
>  > +     /*printk(KERN_ERR"mrv_set_radio\n");*/
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_RADIO,
>  > +             MRV_CMD_SET_RADIO_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_radio *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->flag = cpu_to_le16(1);
>  > +     data->preamble = cpu_to_le16(preamble);
>  > +     data->enable = cpu_to_le16(enable);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set radio\n");
>  > +             return -1;
>  > +     }
>  > +     return 0;
>  > +}
>  > +
>  > +/*
>  > +static int mrv_set_allowed_rates(struct mrv_priv *priv, int allowg)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_rates *data;
>  > +     int i;
>  > +
>  > +     printk(KERN_ERR"mrv_set_allowed_rates\n");
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_RATES,
>  > +             MRV_CMD_SET_RATES_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_rates *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->fixedrate = 0;
>  > +     data->fixedindex = 0;
>  > +
>  > +     for (i = 0; i < 4; i++)
>  > +             data->rates[i] = i;
>  > +
>  > +     for (; i < 14; i++)
>  > +             if (allowg) data->rates[i] = i;
>  > +             else data->rates[i] = 0;
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set rates\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +*/
>  > +
>  > +static int mrv_set_slot(struct mrv_priv *priv, int shortslot)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_slot *data;
>  > +
>  > +     /*printk(KERN_ERR"mrv_set_slot\n");*/
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_SLOT,
>  > +             MRV_CMD_SET_SLOT_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_slot *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->action = cpu_to_le16(1);
>  > +     data->shortslot = shortslot;
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set slot\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_prescan(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +
>  > +     printk(KERN_ERR"mrv_set_prescan\n");
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_PRESCAN,
>  > +             MRV_CMD_SET_PRESCAN_SZ, 0, 1);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set prescan\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_postscan(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +
>  > +     printk(KERN_ERR"mrv_set_postscan\n");
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_POSTSCAN,
>  > +             MRV_CMD_SET_POSTSCAN_SZ, 0, 1);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set postscan\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_channel(struct mrv_priv *priv,
>  > +                        struct ieee80211_channel *channel)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_channel *data;
>  > +     int ch;
>  > +
>  > +     ch = ieee80211_frequency_to_channel(channel->center_freq);
>  > +
>  > +     printk(KERN_ERR"mrv_set_channel %i\n", ch);
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_CHANNEL,
>  > +             MRV_CMD_SET_CHANNEL_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_channel *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->flag = cpu_to_le16(1);
>  > +     data->ch = ch;
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set channel\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_mac_addr(struct mrv_priv *priv, u8 addr[6])
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_mac_addr *data;
>  > +
>  > +     printk(KERN_ERR"mrv_set_mac\n");
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_MAC_ADDR,
>  > +             MRV_CMD_SET_MAC_ADDR_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_mac_addr *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     memcpy(data->addr, addr, 6);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set mac address\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_set_bssid(struct mrv_priv *priv, u8 addr[6])
>  > +{
>  > +     int i;
>  > +     u32 reg;
>  > +
>  > +     printk(KERN_ERR"mrv_set_bssid\n");
>  > +
>  > +     reg = mrv_reg_read32(priv, MRV_REG_RX_MODE);
>  > +
>  > +     if (is_valid_ether_addr(addr)) {
>  > +             for (i = 0; i < 6; i++)
>  > +                     mrv_reg_write8(priv, MRV_REG_BSSID, addr[i]);
>  > +
>  > +             reg &= ~(2);
>  > +     } else {
>  > +             reg |= (2);
>  > +     }
>  > +
>  > +     mrv_reg_write32(priv, MRV_REG_RX_MODE, reg);
>  > +}
>  > +
>  > +static int mrv_read_config(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_get_config *data;
>  > +     int i;
>  > +
>  > +     /*printk(KERN_ERR"mrv_read_config\n");*/
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_GET_CONFIG,
>  > +                   MRV_CMD_GET_CONFIG_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_get_config *)MRV_CMD_PAYLOAD(cmd);
>  > +     data->Magic = cpu_to_le32(priv->magic_dma);
>  > +
>  > +     for (i = 0; i < MRV_CMD_GET_CONFIG_SZ; i++)
>  > +             ((u8 *)data)[i] = 0;
>  > +
>  > +     for (i = 0; i < 6; i++)
>  > +             data->MacAdr[i] = 0xff;
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not read CFG\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     priv->AntNum = le16_to_cpu(data->AntNum);
>  > +     priv->FwVer = le32_to_cpu(data->FwVer);
>  > +     priv->HwVer = le16_to_cpu(data->HwVer);
>  > +     priv->TxRingNum = le16_to_cpu(data->TxRingNum);
>  > +     priv->RegionCode = le16_to_cpu(data->RegionCode);
>  > +     priv->TxHwDma0 = le32_to_cpu(data->TxRing0) & 0xffff;
>  > +     priv->TxHwDma1 = le32_to_cpu(data->TxRing1) & 0xffff;
>  > +     priv->TxHwDma2 = le32_to_cpu(data->TxRing2) & 0xffff;
>  > +     priv->TxHwDma3 = le32_to_cpu(data->TxRing3) & 0xffff;
>  > +     priv->RxHwDmaR = le32_to_cpu(data->RxRingR) & 0xffff;
>  > +     priv->RxHwDmaW = le32_to_cpu(data->RxRingW) & 0xffff;
>  > +
>  > +     SET_IEEE80211_PERM_ADDR(priv->dev, data->MacAdr);
>  > +     printk(KERN_INFO"Card mac address is "MAC_FMT"\n",
>  > +                     MAC_ARG(priv->dev->wiphy->perm_addr));
>  > +     printk(KERN_INFO"Fw V %x, Hw V %x, Antennas: %x, Region code %d\n",
>  > +                     priv->FwVer, priv->HwVer, priv->AntNum, priv->RegionCode);
>  > +     /*printk(KERN_ERR"~mrv_read_config\n");*/
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_alloc_rxring(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_rx_descriptor *v;/*,*_v;*/
>  > +     dma_addr_t p;/*,_p;*/
>  > +     int i;
>  > +     /*printk(KERN_ERR"mrv_alloc_rxring\n");
>  > +
>  > +     _v = (struct mrv_rx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_rx_descriptor), &_p);*/
>  > +     for (i = 0; i < MRV_RX_DESC_NUM; i++) {
>  > +             v = (struct mrv_rx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_rx_descriptor), &p);
>  > +             /*              v = _v + i; p= _p + i*sizeof(struct mrv_rx_descriptor );*/
>  > +             if (v == NULL) {
>  > +                     printk(KERN_ERR"Can't allocate RX descriptor memory\n");
>  > +                     /*FIXME dealloc what we done */
>  > +                     return -ENOMEM;
>  > +             }
>  > +
>  > +             v->drvowner = 0;
>  > +             v->status = cpu_to_le16(1);
>  > +
>  > +             priv->rx_ring_dma[i] = p;
>  > +             priv->rx_ring_virt[i] = v;
>  > +             priv->rx_skb[i] = dev_alloc_skb(MRV_RX_PAYLOAD_LEN);
>  > +
>  > +             if (priv->rx_skb[i] == NULL) {
>  > +                     printk(KERN_ERR"Can't allocate RX skb memory\n");
>  > +                     /*FIXME dealloc what we done */
>  > +                     return -ENOMEM;
>  > +             }
>  > +
>  > +             priv->rx_ring_virt[i]->dma_data = cpu_to_le32(
>  > +                             pci_map_single(priv->pdev, priv->rx_skb[i]->data,
>  > +                             MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE));
>  > +
>  > +             if (i != 0)
>  > +                     priv->rx_ring_virt[i-1]->dma_next = cpu_to_le32(p);
>  > +     }
>  > +     priv->rx_ring_virt[i-1]->dma_next = cpu_to_le32(priv->rx_ring_dma[0]);
>  > +     priv->rx_idx = 0;
>  > +
>  > +     /*printk(KERN_ERR"~mrv_alloc_rxring\n");*/
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_alloc_txring(struct mrv_priv *priv)
>  > +{
>  > +     struct mrv_tx_descriptor *v;/*,*_v;*/
>  > +     dma_addr_t p;/*,_p;*/
>  > +     int i;
>  > +
>  > +     printk(KERN_ERR"mrv_alloc_txring\n");
>  > +     for (i = 0; i < MRV_TX_DESC_NUM; i++) {
>  > +             v = (struct mrv_tx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_tx_descriptor), &p);
>  > +             /*              v = _v + i; p= _p + i*sizeof(struct mrv_tx_descriptor );*/
>  > +             if (v == NULL) {
>  > +                     printk(KERN_ERR"Can't allocate TX descriptor memory\n");
>  > +                     /*FIXME dealloc what we done */
>  > +                     return -ENOMEM;
>  > +             }
>  > +
>  > +             priv->tx_ring_dma[i] = p;
>  > +             priv->tx_ring_virt[i] = v;
>  > +
>  > +             if (i != 0)
>  > +                     priv->tx_ring_virt[i-1]->dma_next = cpu_to_le32(p);
>  > +     }
>  > +     priv->tx_ring_virt[i-1]->dma_next = cpu_to_le32(priv->tx_ring_dma[0]);
>  > +     priv->tx_r_idx = 0;
>  > +     priv->tx_w_idx = 0;
>  > +     priv->tx_pending = 0;
>  > +
>  > +     printk(KERN_ERR"~mrv_alloc_txring\n");
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_set_dma_rings(struct mrv_priv *priv)
>  > +{
>  > +     /*printk(KERN_ERR"mrv_set_dma_rings %i, %x\n", priv->RxHwDmaR,
>  > +              priv->rx_ring_dma[0]);*/
>  > +     mrv_mem_write32(priv, priv->RxHwDmaR, priv->rx_ring_dma[0]);
>  > +     /*printk(KERN_ERR"mrv_set_dma_rings 1\n");*/
>  > +     mrv_mem_write32(priv, priv->RxHwDmaW, priv->rx_ring_dma[0]);
>  > +     /*printk(KERN_ERR"mrv_set_dma_rings 2\n");*/
>  > +     mrv_mem_write32(priv, priv->TxHwDma0, priv->tx_ring_dma[0]);
>  > +     /*printk(KERN_ERR"~mrv_set_dma_rings\n");*/
>  > +}
>  > +
>  > +static void mrv_stop(struct ieee80211_hw *dev)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     /*printk(KERN_ERR"mrv_stop\n");*/
>  > +
>  > +     priv->up = 0;
>  > +     tasklet_disable(&priv->mrv_rx_tasklet);
>  > +     tasklet_disable(&priv->mrv_tx_cb_tasklet);
>  > +     mrv_mem_write32(priv, priv->TxHwDma0, 0);
>  > +     mrv_mem_write32(priv, priv->RxHwDmaR, 0);
>  > +     mrv_mem_write32(priv, priv->RxHwDmaW, 0);
>  > +     mrv_reg_mb(priv);
>  > +     msleep(100); /* random */
>  > +     tasklet_kill(&priv->mrv_rx_tasklet);
>  > +     tasklet_kill(&priv->mrv_tx_cb_tasklet);
>  > +     mrv_free_rx_ring(priv);
>  > +     mrv_free_tx_ring(priv);
>  > +}
>  > +
>  > +static int mrv_start(struct ieee80211_hw *dev)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     /*printk(KERN_ERR"mrv_start\n");*/
>  > +
>  > +     priv->up = 1;
>  > +     /*printk(KERN_ERR"mrv_start after up\n");*/
>  > +     tasklet_enable(&priv->mrv_rx_tasklet);
>  > +     tasklet_enable(&priv->mrv_tx_cb_tasklet);
>  > +     /*printk(KERN_ERR"mrv_start after tasklet\n");*/
>  > +     mrv_alloc_rxring(priv);
>  > +     mrv_alloc_txring(priv);
>  > +     /*printk(KERN_ERR"mrv_start after rings\n");*/
>  > +
>  > +     mrv_set_dma_rings(priv);
>  > +     /*printk(KERN_ERR"mrv_start after hw\n");*/
>  > +
>  > +     /* Suspect that all commands must be sent AFTER set radio. Including the
>  > +      * get_hw_spec. But radio should be already enabled by default. Just make
>  > +      * sure we use AUTO preamble here
>  > +     */
>  > +
>  > +     /*
>  > +     if (mrv_set_prescan(priv)) {
>  > +       printk(KERN_ERR"Failed to prescan\n");
>  > +       return -1;
>  > +     } else {
>  > +       printk(KERN_ERR"Succeeded to prescan\n");
>  > +       }*/
>  > +
>  > +     /*mrv_set_channel(priv, 5);*/
>  > +     /*printk(KERN_ERR"mrv_start after channel\n");*/
>  > +     mrv_set_antenna(priv, MRV_ANTENNA_RXA, 0xffff);
>  > +     mrv_set_antenna(priv, MRV_ANTENNA_TXA, 0x2);
>  > +     /*printk(KERN_ERR"mrv_start after antenna\n");*/
>  > +
>  > +     if (priv->AntNum == 2) {
>  > +             mrv_set_antenna(priv, MRV_ANTENNA_RXB, 0xffff);
>  > +             mrv_set_antenna(priv, MRV_ANTENNA_TXB, 0x2);
>  > +     }
>  > +     /*printk(KERN_ERR"mrv_start after antenna2\n");*/
>  > +
>  > +     mrv_set_radio(priv, 1, MRV_PREAMBLE_AUTO);
>  > +     /*printk(KERN_ERR"mrv_start after radio\n");*/
>  > +
>  > +     mrv_set_txpower(priv, 10);
>  > +
>  > +     /*printk(KERN_ERR"~mrv_start\n");*/
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_set_promisc(struct mrv_priv *priv, int enable)
>  > +{
>  > +     u32 reg;
>  > +     printk(KERN_ERR"mrv_set_promisc %i\n", enable);
>  > +
>  > +     reg = mrv_reg_read32(priv, MRV_REG_RX_MODE);
>  > +     if (enable)
>  > +             reg |= 1;
>  > +     else
>  > +             reg &= ~1;
>  > +     mrv_reg_write32(priv, MRV_REG_RX_MODE, reg);
>  > +}
>  > +
>  > +
>  > +static void mrv_configure_filter(struct ieee80211_hw *dev,
>  > +                              unsigned int changed_flags,
>  > +                              unsigned int *total_flags,
>  > +                              int mc_count, struct dev_mc_list *mclist)
>  > +{
>  > +     printk(KERN_ERR"mrv_configure_filter %x\n", changed_flags);
>  > +     *total_flags &= FIF_BCN_PRBRESP_PROMISC;
>  > +
>  > +     if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
>  > +             if (*total_flags & FIF_PROMISC_IN_BSS) {
>  > +               mrv_set_promisc(dev->priv, 1);
>  > +             } else {
>  > +               mrv_set_promisc(dev->priv, 0);
>  > +             }
>  > +     }
>  > +     printk(KERN_ERR"~mrv_configure_filter\n");
>  > +}
>  > +
>  > +static int mrv_config_interface(struct ieee80211_hw *dev,
>  > +                             struct ieee80211_vif *vif,
>  > +                             struct ieee80211_if_conf *conf)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     int err = 0;
>  > +
>  > +     /*printk(KERN_ERR"mrv_config_interf\n");*/
>  > +     memcpy(priv->bssid, conf->bssid, ETH_ALEN);
>  > +     mrv_set_bssid(priv, priv->bssid);
>  > +     /*printk(KERN_ERR"~mrv_config_interf\n");*/
>  > +
>  > +     return err;
>  > +}
>  > +
>  > +static int mrv_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     int err;
>  > +
>  > +     printk(KERN_ERR"mrv_config: center_freq %i\n", conf->channel->center_freq);
>  > +
>  > +     err = mrv_set_channel(priv, conf->channel);
>  > +     if (err) {
>  > +             printk(KERN_ERR"~Failed to set channel\n");
>  > +             return -1;
>  > +     } else {
>  > +       printk(KERN_ERR"Succeeded setting channel\n");
>  > +     }
>  > +     /* TODO in monitor mode make sure it use IEEE80211G mode */
>  > +     /*if (conf->phymode == MODE_IEEE80211G)
>  > +             err = mrv_set_allowed_rates(priv, 1);
>  > +     else
>  > +             err = mrv_set_allowed_rates(priv, 0);
>  > +
>  > +     if (err) {
>  > +             printk(KERN_ERR"~Failed to set rates\n");
>  > +             return -1;
>  > +     }
>  > +     */
>  > +     err = mrv_set_slot(priv, conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME);
>  > +     if (err) {
>  > +             printk(KERN_ERR"~Failed to set slot\n");
>  > +             return -1;
>  > +     }
>  > +     /*we must set again bssid filter after changing ch ?*/
>  > +     mrv_set_bssid(priv, priv->bssid);
>  > +
>  > +     /* we must set the promisc mode *after* changing ch */
>  > +     /*mrv_set_promisc(priv,priv->mode == IEEE80211_IF_TYPE_MNTR);*/
>  > +     mrv_set_promisc(priv, 1);
>  > +
>  > +     /*mrv_set_postscan(priv);*/
>  > +
>  > +     printk(KERN_ERR"~mrv_config\n");
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static int mrv_set_rts_threshold(struct ieee80211_hw *dev, u32 val)
>  > +{
>  > +     struct mrv_cmd_hdr  *cmd;
>  > +     struct mrv_cmd_set_rts_threshold *data;
>  > +     struct mrv_priv *priv = dev->priv;
>  > +
>  > +     printk(KERN_ERR"set_rts\n");
>  > +
>  > +     cmd = mrv_cmd(priv, MRV_CMD_SET_RTS_THRESHOLD,
>  > +             MRV_CMD_SET_RTS_THRESHOLD_SZ, 0, 1);
>  > +
>  > +     data = (struct mrv_cmd_set_rts_threshold *)MRV_CMD_PAYLOAD(cmd);
>  > +
>  > +     data->threshold = cpu_to_le32(val);
>  > +
>  > +     if (mrv_send_cmd_sync(priv)) {
>  > +             printk(KERN_ERR"Could not set rts threshold\n");
>  > +             return -1;
>  > +     }
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_remove_interface(struct ieee80211_hw *dev,
>  > +                              struct ieee80211_if_init_conf *conf)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     printk(KERN_ERR"mrv_remove_interface\n");
>  > +     priv->mode = IEEE80211_IF_TYPE_INVALID;
>  > +     printk(KERN_ERR"~mrv_remove_interface\n");
>  > +}
>  > +
>  > +static int mrv_add_interface(struct ieee80211_hw *dev,
>  > +                          struct ieee80211_if_init_conf *conf)
>  > +{
>  > +     struct mrv_priv *priv = dev->priv;
>  > +     u8 bssid[] = {0, 0, 0, 0, 0, 0};
>  > +
>  > +     /*printk(KERN_ERR"mrv_add\n");*/
>  > +     /* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
>  > +     if (priv->mode != IEEE80211_IF_TYPE_INVALID /*IEEE80211_IF_TYPE_MGMT*/)
>  > +             return -1;
>  > +
>  > +     memcpy(priv->bssid, bssid, ETH_ALEN);
>  > +     priv->mode = conf->type;
>  > +     mrv_set_mac_addr(priv, conf->mac_addr);
>  > +
>  > +     return 0;
>  > +}
>  > +
>  > +static void mrv_set_d80211_stuff(struct mrv_priv *priv)
>  > +{
>  > +     /* printk(KERN_ERR"mrv_set_d80211_stuff\n");
>  > +     memcpy(priv->channels, mrv_channels, sizeof(mrv_channels));
>  > +     memcpy(priv->rates, mrv_rates, sizeof(mrv_rates));
>  > +     priv->modes[0].mode = MODE_IEEE80211G;
>  > +     priv->modes[0].num_rates = ARRAY_SIZE(mrv_rates);
>  > +     priv->modes[0].rates = priv->rates;
>  > +     priv->modes[0].num_channels = ARRAY_SIZE(mrv_channels);
>  > +     priv->modes[0].channels = priv->channels;
>  > +     priv->modes[1].mode = MODE_IEEE80211B;
>  > +     priv->modes[1].num_rates = 4;
>  > +     priv->modes[1].rates = priv->rates;
>  > +     priv->modes[1].num_channels = ARRAY_SIZE(mrv_channels);
>  > +     priv->modes[1].channels = priv->channels;*/
>  > +     priv->dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING /*|
>  > +                  IEEE80211_HW_WEP_INCLUDE_IV |
>  > +                  IEEE80211_HW_DATA_NULLFUNC_ACK*/;
>  > +     priv->dev->extra_tx_headroom = 8; /* 6 bytes addr4, 2 bytes FW len */
>  > +     priv->dev->queues = 1;
>  > +     priv->dev->max_rssi = 100; /* just to avoid dividing by zero */
>  > +     /*priv->dev->channel_change_time = 300000;*/
>  > +     priv->mode = IEEE80211_IF_TYPE_INVALID/*IEEE80211_IF_TYPE_MGMT*/;
>  > +     /*priv->mode = IEEE80211_IF_TYPE_STA;
>  > +       printk(KERN_ERR"~mrv_set_d80211_stuff\n");*/
>  > +}
>  > +
>  > +static struct ieee80211_ops mrv_ops = {
>  > +     .tx                     = mrv_tx,
>  > +     .start                  = mrv_start,
>  > +     .stop                   = mrv_stop,
>  > +     .add_interface          = mrv_add_interface,
>  > +     .remove_interface       = mrv_remove_interface,
>  > +     .config                 = mrv_config,
>  > +     .config_interface       = mrv_config_interface,
>  > +     .configure_filter       = mrv_configure_filter,
>  > +     .set_rts_threshold      = mrv_set_rts_threshold,
>  > +
>  > +};
>  > +
>  > +const struct mrv_rate mrv_supported_rates[12] = {
>  > +     { .bitrate = 10,
>  > +       .hw_value = 0 | (1<<4),
>  > +       /*      .flags = IEEE80211_CCK_RATE_1MB_MASK*/
>  > +     },
>  > +     { .bitrate = 20,
>  > +       .hw_value = 1 | (1<<4),
>  > +       /*      .flags = IEEE80211_CCK_RATE_2MB_MASK*/
>  > +     },
>  > +     { .bitrate = 55,
>  > +       .hw_value = 2 | (1<<4),
>  > +       /*      .flags = IEEE80211_CCK_RATE_5MB_MASK*/
>  > +     },
>  > +     { .bitrate = 110,
>  > +       .hw_value = 3 | (1<<4),
>  > +       /*      .flags = IEEE80211_CCK_RATE_11MB_MASK*/
>  > +     },
>  > +     { .bitrate = 60,
>  > +       .hw_value = 4 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_6MB_MASK*/
>  > +     },
>  > +     { .bitrate = 90,
>  > +       .hw_value = 5 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_9MB_MASK*/
>  > +     },
>  > +     { .bitrate = 120,
>  > +       .hw_value = 6 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_12MB_MASK*/
>  > +     },
>  > +     { .bitrate = 180,
>  > +       .hw_value = 7 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_18MB_MASK*/
>  > +     },
>  > +     { .bitrate = 240,
>  > +       .hw_value = 8 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_24MB_MASK*/
>  > +     },
>  > +     { .bitrate = 360,
>  > +       .hw_value = 9 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_36MB_MASK*/
>  > +     },
>  > +     { .bitrate = 480,
>  > +       .hw_value = 10 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_48MB_MASK*/
>  > +     },
>  > +     { .bitrate = 540,
>  > +       .hw_value = 11 | (1<<4),
>  > +       /*      .flags = IEEE80211_OFDM_RATE_54MB_MASK*/
>  > +     },
>  > +};
>  > +
>  > +static unsigned int
>  > +mrv_copy_channels(struct mrv_hw *mh,
>  > +               struct ieee80211_channel *channels,
>  > +               unsigned int max)
>  > +{
>  > +     unsigned int i, count, freq, ch;
>  > +     /*printk(KERN_ERR"mrv_copy_channels\n");*/
>  > +
>  > +     count = 0;
>  > +     for (i = 0; i < 14; i++) {
>  > +             ch = i + 1;
>  > +             freq = ieee80211chan2mhz(ch);
>  > +
>  > +             /*printk(KERN_ERR"mrv_copy_channel %i\n", i);*/
>  > +             /* Write channel info and increment counter */
>  > +             channels[count].center_freq = freq;
>  > +             channels[count].band = IEEE80211_BAND_2GHZ;
>  > +             count++;
>  > +     }
>  > +     /*printk(KERN_ERR"~mrv_copy_channels\n");*/
>  > +     return count;
>  > +}
>  > +
>  > +static unsigned int
>  > +mrv_copy_rates(struct ieee80211_rate *rates,
>  > +            const struct mrv_rate *rt,
>  > +            unsigned int max)
>  > +{
>  > +     unsigned int i, count;
>  > +     /*printk(KERN_ERR"mrv_copy_rates\n");*/
>  > +
>  > +     if (rt == NULL) {
>  > +             printk(KERN_ERR"~mrv_copy_rates (rt == NULL)\n");
>  > +             return 0;
>  > +     }
>  > +     for (i = 0, count = 0; i < 12 && max > 0; i++) {
>  > +             /*printk(KERN_ERR"mrv_copy_rate %i: %i\n", i,rt[i].bitrate);*/
>  > +             rates[count].bitrate = rt[i].bitrate;
>  > +             rates[count].hw_value = rt[i].hw_value;
>  > +             /*rates[count].flags = rt->flags;*/
>  > +             count++;
>  > +             max--;
>  > +     }
>  > +
>  > +     /*printk(KERN_ERR"~mrv_copy_rates\n");*/
>  > +     return count;
>  > +}
>  > +
>  > +void
>  > +mrv_debug_dump_bands(struct mrv_priv *mp)
>  > +{
>  > +     unsigned int b, i;
>  > +
>  > +     BUG_ON(!mp->sbands);
>  > +
>  > +     for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
>  > +             struct ieee80211_supported_band *band = &mp->sbands[b];
>  > +             char bname[5];
>  > +             switch (band->band) {
>  > +             case IEEE80211_BAND_2GHZ:
>  > +                     strcpy(bname, "2 GHz");
>  > +                     break;
>  > +             case IEEE80211_BAND_5GHZ:
>  > +                     strcpy(bname, "5 GHz");
>  > +                     break;
>  > +             default:
>  > +                     printk(KERN_DEBUG "Band not supported: %d\n",
>  > +                             band->band);
>  > +                     return;
>  > +             }
>  > +             printk(KERN_DEBUG "Band %s: channels %d, rates %d\n", bname,
>  > +                             band->n_channels, band->n_bitrates);
>  > +             printk(KERN_DEBUG " channels:\n");
>  > +             for (i = 0; i < band->n_channels; i++)
>  > +                     printk(KERN_DEBUG "  ch %3d freq %d hwv %.4x fl %.4x\n",
>  > +                                     ieee80211_frequency_to_channel(
>  > +                                             band->channels[i].center_freq),
>  > +                                     band->channels[i].center_freq,
>  > +                                     band->channels[i].hw_value,
>  > +                                     band->channels[i].flags);
>  > +             printk(KERN_DEBUG " rates:\n");
>  > +             for (i = 0; i < band->n_bitrates; i++)
>  > +                     printk(KERN_DEBUG "  bitr %4d hw_val %.4x fl %.4x hw_val_short %.4x\n",
>  > +                                     band->bitrates[i].bitrate,
>  > +                                     band->bitrates[i].hw_value,
>  > +                                     band->bitrates[i].flags,
>  > +                                     band->bitrates[i].hw_value_short);
>  > +     }
>  > +}
>  > +
>  > +static int
>  > +mrv_getchannels(struct ieee80211_hw *hw)
>  > +{
>  > +     struct mrv_priv *mrv_priv = hw->priv;
>  > +     struct mrv_hw *mh = mrv_priv->mh;
>  > +     struct ieee80211_supported_band *sbands = mrv_priv->sbands;
>  > +     /*const struct mrv_rate_table *hw_rates;*/
>  > +     unsigned int max_r, max_c, count_r, count_c;
>  > +
>  > +     struct ieee80211_supported_band *sbandg =
>  > +       &sbands[IEEE80211_BAND_2GHZ];
>  > +     /*struct ieee80211_supported_band *sbanda =
>  > +       &sbands[IEEE80211_BAND_5GHZ];*/
>  > +
>  > +     BUILD_BUG_ON(ARRAY_SIZE(mrv_priv->sbands) < IEEE80211_NUM_BANDS);
>  > +
>  > +     /*printk(KERN_ERR"mrv_getchannels\n");*/
>  > +
>  > +     max_r = ARRAY_SIZE(mrv_priv->rates);
>  > +     max_c = ARRAY_SIZE(mrv_priv->channels);
>  > +     count_r = count_c = 0;
>  > +
>  > +     /* 2GHz band */
>  > +
>  > +             sbandg->bitrates = mrv_priv->rates;
>  > +             sbandg->channels = mrv_priv->channels;
>  > +
>  > +             sbandg->band = IEEE80211_BAND_2GHZ;
>  > +             sbandg->n_channels = mrv_copy_channels(mh, sbandg->channels,
>  > +                                                    max_c);
>  > +
>  > +             /*hw_rates = mrv_hw_get_rate_table(mh, mode2g);*/
>  > +             sbandg->n_bitrates = mrv_copy_rates(sbandg->bitrates,
>  > +                                                 mrv_supported_rates, max_r);
>  > +             /*printk(KERN_ERR"mrv_getchannels n_bitrates %i\n", sbandg->n_bitrates);*/
>  > +
>  > +             count_c = sbandg->n_channels;
>  > +             count_r = sbandg->n_bitrates;
>  > +
>  > +             hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sbandg;
>  > +
>  > +             max_r -= count_r;
>  > +             max_c -= count_c;
>  > +
>  > +     /* 5GHz band */
>  > +             /*
>  > +             sbanda->bitrates = &mrv_priv->rates[count_r];
>  > +             sbanda->channels = &mrv_priv->channels[count_c];
>  > +
>  > +             sbanda->band = IEEE80211_BAND_5GHZ;
>  > +             sbanda->n_channels = 0; //mrv_copy_channels(mh, sbanda->channels,
>  > +                                      AR5K_MODE_11A, max_c);//
>  > +
>  > +             //hw_rates = mrv_hw_get_rate_table(mh, AR5K_MODE_11A);
>  > +             sbanda->n_bitrates = 0; //ath5k_copy_rates(sbanda->bitrates,
>  > +                                     hw_rates, max_r);//
>  > +
>  > +             hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sbanda;
>  > +             */
>  > +             mrv_debug_dump_bands(mrv_priv);
>  > +
>  > +             /*printk(KERN_ERR"~mrv_getchannels\n");*/
>  > +     return 0;
>  > +}
>  > +
>  > +static int __devinit mrv_init_one(struct pci_dev *pdev,
>  > +                               const struct pci_device_id *ent)
>  > +{
>  > +     struct ieee80211_hw *dev = NULL;
>  > +     struct mrv_priv *priv;
>  > +     unsigned long bar1_start, bar1_len, bar1_flags;
>  > +     unsigned long bar2_start, bar2_len, bar2_flags;
>  > +     void *bar1_addr = NULL, *bar2_addr = NULL;
>  > +     int err;
>  > +
>  > +     /printk(KERN_ERR"mrv_init_one\n");*/
>  > +     err = pci_enable_device(pdev);
>  > +
>  > +     bar1_start = pci_resource_start(pdev, 0);
>  > +     bar1_len = pci_resource_len(pdev, 0);
>  > +     bar1_flags = pci_resource_flags(pdev, 0);
>  > +
>  > +     if (!(bar1_flags & IORESOURCE_MEM)) {
>  > +             printk(KERN_ERR"bar1 resource type is not memory\n");
>  > +             err = -ENODEV;
>  > +             goto fail_disable_device;
>  > +     }
>  > +
>  > +     bar2_start = pci_resource_start(pdev, 1);
>  > +     bar2_len = pci_resource_len(pdev, 1);
>  > +     bar2_flags = pci_resource_flags(pdev, 1);
>  > +
>  > +     if (!(bar2_flags & IORESOURCE_MEM)) {
>  > +             printk(KERN_ERR"bar1 resource type is not memory\n");
>  > +             err = -ENODEV;
>  > +             goto fail_disable_device;
>  > +     }
>  > +
>  > +     err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
>  > +     if (err) {
>  > +             printk(KERN_ERR"No usable DMA configuration.\n");
>  > +             goto fail_disable_device;
>  > +     }
>  > +
>  > +     bar1_addr = ioremap_nocache(bar1_start, bar1_len);
>  > +     if (bar1_addr == NULL) {
>  > +             printk(KERN_ERR"Error calling ioremap for bar1.\n");
>  > +             err = -EIO;
>  > +             goto fail_disable_device;
>  > +     }
>  > +
>  > +     bar2_addr = ioremap_nocache(bar2_start, bar2_len);
>  > +     if (bar2_addr == NULL) {
>  > +             printk(KERN_ERR"Error calling ioremap for bar2.\n");
>  > +             err = -EIO;
>  > +             goto fail_iounmap;
>  > +     }
>  > +
>  > +     err = pci_request_regions(pdev, DRV_NAME);
>  > +     if (err) {
>  > +             printk(KERN_ERR"Error calling pci_request_regions.\n");
>  > +             goto fail_iounmap;
>  > +     }
>  > +     pci_set_master(pdev);
>  > +     err = pci_set_mwi(pdev);
>  > +
>  > +
>  > +     dev = ieee80211_alloc_hw(sizeof(*priv), &mrv_ops);
>  > +     if (!dev) {
>  > +             printk(KERN_ERR "%s : can't allocate d80211 \n", pci_name(pdev));
>  > +             err = -ENOMEM;
>  > +             goto fail_release_regions;
>  > +     }
>  > +
>  > +     priv = dev->priv;
>  > +     priv->pdev = pdev;
>  > +     priv->dev = dev;
>  > +
>  > +     /*SET_MODULE_OWNER(dev);*/
>  > +
>  > +     SET_IEEE80211_DEV(dev, &pdev->dev);
>  > +     pci_set_drvdata(pdev, dev);
>  > +
>  > +     priv->bar1 = bar1_addr;
>  > +     priv->bar1_phys = bar1_start;
>  > +     priv->bar2 = bar2_addr;
>  > +     priv->bar2_phys = bar2_start;
>  > +
>  > +     sema_init(&priv->cmd_sem, 1);
>  > +
>  > +     tasklet_init(&priv->mrv_rx_tasklet,
>  > +                  (void(*)(unsigned long)) mrv_rx_tasklet,
>  > +                  (unsigned long)priv);
>  > +
>  > +     tasklet_init(&priv->mrv_tx_cb_tasklet,
>  > +                  (void(*)(unsigned long)) mrv_tx_cb_tasklet,
>  > +                  (unsigned long)priv);
>  > +
>  > +     tasklet_disable(&priv->mrv_rx_tasklet);
>  > +     tasklet_disable(&priv->mrv_tx_cb_tasklet);
>  > +
>  > +     init_waitqueue_head(&priv->wait_command_queue);
>  > +
>  > +     spin_lock_init(&priv->irq_th_lock);
>  > +     spin_lock_init(&priv->tx_lock);
>  > +
>  > +     priv->fw_load = 0;
>  > +     priv->up = 0;
>  > +
>  > +     mrv_init_cmd(priv);
>  > +
>  > +     err = mrv_hw_start(priv);
>  > +     if (err)
>  > +             goto fail_deinit_hw;
>  > +
>  > +     mrv_read_config(priv);
>  > +
>  > +     mrv_set_d80211_stuff(priv);
>  > +
>  > +     err = mrv_getchannels(dev);
>  > +     if (err) {
>  > +             printk(KERN_ERR"%s can't register hwmodes\n", pci_name(pdev));
>  > +             goto fail_stop_hw;
>  > +     }
>  > +     /*
>  > +     err = ieee80211_register_hwmode(dev, &priv->modes[0]);
>  > +     if (err) {
>  > +             printk(KERN_ERR"%s can't register hwmode\n", pci_name(pdev));
>  > +             goto fail_stop_hw;
>  > +     }
>  > +
>  > +     err = ieee80211_register_hwmode(dev, &priv->modes[1]);
>  > +     if (err) {
>  > +             printk(KERN_ERR"%s can't register hwmode\n", pci_name(pdev));
>  > +             goto fail_stop_hw;
>  > +     }
>  > +     */
>  > +
>  > +     /*printk(KERN_ERR"ieee80211_register_hw\n");*/
>  > +     err = ieee80211_register_hw(dev);
>  > +     if (err) {
>  > +             printk(KERN_ERR"%s can't register HW\n", pci_name(pdev));
>  > +             goto fail_stop_hw;
>  > +     }
>  > +
>  > +     /*printk(KERN_ERR"~mrv_init_one\n");*/
>  > +     return 0;
>  > +fail_stop_hw:
>  > +     mrv_hw_halt(priv);
>  > +fail_deinit_hw:
>  > +     mrv_deinit_cmd(priv);
>  > +     pci_set_drvdata(pdev, NULL);
>  > +     ieee80211_free_hw(dev);
>  > +fail_release_regions:
>  > +     pci_release_regions(pdev);
>  > +fail_iounmap:
>  > +     if (bar1_addr)
>  > +             iounmap(bar1_addr);
>  > +     if (bar2_addr)
>  > +             iounmap(bar2_addr);
>  > +fail_disable_device:
>  > +     pci_disable_device(pdev);
>  > +     pci_set_drvdata(pdev, NULL);
>  > +
>  > +     return err;
>  > +}
>  > +
>  > +static void __devexit mrv_remove_one(struct pci_dev *pdev)
>  > +{
>  > +     struct ieee80211_hw *dev = pci_get_drvdata(pdev);
>  > +     struct mrv_priv *priv;
>  > +
>  > +     /*printk(KERN_ERR"mrv_remove\n");*/
>  > +     if (dev) {
>  > +             priv = dev->priv;
>  > +             mrv_hw_halt(priv);
>  > +
>  > +             ieee80211_unregister_hw(dev);
>  > +             mrv_deinit_cmd(priv);
>  > +
>  > +             if (priv->bar1)
>  > +                     iounmap(priv->bar1);
>  > +             if (priv->bar2)
>  > +                     iounmap(priv->bar2);
>  > +
>  > +             pci_release_regions(pdev);
>  > +             pci_disable_device(pdev);
>  > +
>  > +             pci_set_drvdata(pdev, NULL);
>  > +
>  > +             ieee80211_free_hw(dev);
>  > +      }
>  > +}
>  > +
>  > +
>  > +static struct pci_driver mrv_pci_driver = {
>  > +     .name           = DRV_NAME,
>  > +     .id_table               = mrv_pci_tbl,
>  > +     .probe          = mrv_init_one,
>  > +     .remove         = __devexit_p(mrv_remove_one),
>  > +};
>  > +
>  > +
>  > +static int __init mrv_init_module(void)
>  > +{
>  > +     printk(KERN_INFO"%s\n", DRV_DESCRIPTION);
>  > +     printk(KERN_INFO"%s\n", DRV_COPYRIGHT);
>  > +
>  > +     return pci_register_driver(&mrv_pci_driver);
>  > +}
>  > +
>  > +
>  > +static void __exit mrv_cleanup_module(void)
>  > +{
>  > +     pci_unregister_driver(&mrv_pci_driver);
>  > +}
>  > +
>  > +module_init(mrv_init_module);
>  > +module_exit(mrv_cleanup_module);
>  > +
>  > diff --git a/drivers/net/wireless/mrv8k/mrv8.h b/drivers/net/wireless/mrv8k/mrv8.h
>  > new file mode 100644
>  > index 0000000..fdeb1f3
>  > --- /dev/null
>  > +++ b/drivers/net/wireless/mrv8k/mrv8.h
>  > @@ -0,0 +1,428 @@
>  > +/*
>  > +     d80211 Marvell Libertas PCI driver
>  > +
>  > +     Adoption for wireless-testing.
>  > +     Copyright (c) 2008 Markus Becker <mab@comnets.uni-bremen.de>
>  > +
>  > +     Copyright (c) 2007 Andrea Merello <andreamrl@tiscali.it>
>  > +
>  > +     Based on existent mrv8k driver
>  > +     Copyright (c) 2005 Luc Saillard <luc@saillard.org>
>  > +
>  > +     Based on BSD malo driver (no code has been copyed. Programming
>  > +     methods, magic values, and card specific programming details
>  > +     has been looked at)
>  > +
>  > +     This program is free software; you can redistribute it and/or modify
>  > +     it under the terms of the GNU General Public License as published by
>  > +     the Free Software Foundation; either version 2 of the License, or
>  > +     (at your option) any later version.
>  > +
>  > +     This program is distributed in the hope that it will be useful,
>  > +     but WITHOUT ANY WARRANTY; without even the implied warranty of
>  > +     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  > +     GNU General Public License for more details.
>  > +
>  > +     You should have received a copy of the GNU General Public License
>  > +     along with this program; see the file COPYING.  If not, write to
>  > +     the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
>  > +     Boston, MA 02110-1301, USA.
>  > +
>  > +*/
>  > +
>  > +#define DRV_COPYRIGHT   "Andrea Merello <andreamrl *at* tiscali.it>\nMarkus Becker <mab *at* comnets.uni-bremen.de>"
>  > +#define DRV_DESCRIPTION "mac80211 Marvell Libertas PCI/PCMCIA driver"
>  > +#define DRV_VERSION  "0.1"
>  > +#define DRV_NAME     "libertaspci"
>  > +#define FW_FIRMWARE_FILENAME "mrv8k-f.fw"
>  > +#define FW_BOOT_FILENAME     "mrv8k-b.fw"
>  > +
>  > +#define MRV_CMD_PKT_SIZE     512
>  > +#define MRV_CMD_MAGIC                0xAA55AA55
>  > +#define MRV_FW_SIGNATURE     0xf0f1f2f4
>  > +
>  > +/* it is intentional we add sizeof(mrv_cmd_hdr) to all commands, but we don't add the header len
>  > + * when we send the MRV_CMD_FW. Bootloader don't want the header len, while firmware seems to
>  > + * need it
>  > + */
>  > +#define MRV_CMD_FW                   0x001
>  > +#define MRV_CMD_GET_CONFIG           0x003
>  > +#define MRV_CMD_GET_CONFIG_SZ                (sizeof(struct mrv_cmd_get_config)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_RADIO            0x01c
>  > +#define MRV_CMD_SET_RADIO_SZ         (sizeof(struct mrv_cmd_set_radio)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_PREAMBLE_AUTO            5
>  > +#define MRV_PREAMBLE_SHORT           1
>  > +#define MRV_PREAMBLE_LONG            3
>  > +#define MRV_CMD_SET_TXPOWER          0x01e
>  > +#define MRV_CMD_SET_TXPOWER_SZ               (sizeof(struct mrv_cmd_set_txpower)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_ANTENNA          0x020
>  > +#define MRV_CMD_SET_ANTENNA_SZ               (sizeof(struct mrv_cmd_set_antenna)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_ANTENNA_RXA                      1
>  > +#define MRV_ANTENNA_TXA                      2
>  > +#define MRV_ANTENNA_RXB                      4
>  > +#define MRV_ANTENNA_TXB                      8
>  > +
>  > +#define MRV_CMD_SET_PRESCAN          0x0107
>  > +#define MRV_CMD_SET_PRESCAN_SZ               sizeof(struct mrv_cmd_hdr)
>  > +#define MRV_CMD_SET_POSTSCAN         0x0108
>  > +#define MRV_CMD_SET_POSTSCAN_SZ              sizeof(struct mrv_cmd_hdr)
>  > +
>  > +#define MRV_CMD_SET_CHANNEL          0x10a /*0x1d for usb*/
>  > +#define MRV_CMD_SET_CHANNEL_SZ               (sizeof(struct mrv_cmd_set_channel)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_RATES            0x110 /*0x22 0x76 0x7f about rates USB*/
>  > +#define MRV_CMD_SET_RATES_SZ         (sizeof(struct mrv_cmd_set_rates)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_RTS_THRESHOLD    0x113
>  > +#define MRV_CMD_SET_RTS_THRESHOLD_SZ (sizeof(struct mrv_cmd_set_rts_threshold)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_SLOT             0x114
>  > +#define MRV_CMD_SET_SLOT_SZ          (sizeof(struct mrv_cmd_set_slot)+sizeof(struct mrv_cmd_hdr))
>  > +#define MRV_CMD_SET_MAC_ADDR         0x202
>  > +#define MRV_CMD_SET_MAC_ADDR_SZ              (sizeof(struct mrv_cmd_set_mac_addr)+sizeof(struct mrv_cmd_hdr))
>  > +
>  > +#define MRV_CMD_PAYLOAD(x) (((u8 *)x) + sizeof(struct mrv_cmd_hdr))
>  > +
>  > +
>  > +#define MRV_INTA_MASK 0x1f
>  > +#define MRV_INTB_MASK 0x1f
>  > +
>  > +#define MRV_REG_CMD_PTR                      0xc10
>  > +#define MRV_REG_STATUS                       0xc14
>  > +#define MRV_REG_GEN_ARM_INT          0xc18
>  > +#define MRV_REG_INTA_MASK            0xc34
>  > +#define MRV_REG_INTB_MASK            0xc3c
>  > +#define MRV_REG_ISR                  0xc30
>  > +#define MRV_REG_RX_MODE                      0xa300
>  > +#define MRV_REG_BSSID                        0xa530
>  > +#define MRV_MEM_CMD_BOOT             0xbef8
>  > +#define MRV_HWMEM_CMD_BOOT   (0xc0000000 | MRV_MEM_CMD_BOOT)
>  > +
>  > +#define PCI_DEVICE_ID_MARVELL_W8K (0x1FA6)
>  > +#define WL3563 0
>  > +#define WL138G 1
>  > +#define W8335 2
>  > +#define WLGENERIC 3
>  > +
>  > +#define MRV_RX_DESC_NUM              128
>  > +#define MRV_RX_PAYLOAD_LEN   (2342 + 8)
>  > +#define MRV_MAX_RX_INT               128
>  > +
>  > +#define MRV_TX_DESC_NUM              128
>  > +
>  > +struct mrv_rate {
>  > +  unsigned short flags;
>  > +  unsigned short bitrate; /* In 100kbit/s */
>  > +  unsigned short hw_value;
>  > +};
>  > +
>  > +struct mrv_hw {
>  > +  unsigned int supported_bands;
>  > +  unsigned int supported_rates;
>  > +
>  > +  unsigned int num_channels;
>  > +
>  > +  const u8 *tx_power_a;
>  > +  const u8 *tx_power_bg;
>  > +  u8 tx_power_default;
>  > +};
>  > +
>  > +/*
>  > +static const struct ieee80211_rate mrv_rates[] = {
>  > +     { .bitrate = 10,
>  > +       .hw_value = 0 | (1<<4),
>  > +       .flags = IEEE80211_CCK_RATE_1MB_MASK },
>  > +     { .bitrate = 20,
>  > +       .hw_value = 1| (1<<4),
>  > +       .flags = IEEE80211_CCK_RATE_2MB_MASK },
>  > +     { .bitrate = 55,
>  > +       .hw_value = 2| (1<<4),
>  > +       .flags = IEEE80211_CCK_RATE_5MB_MASK },
>  > +     { .bitrate = 110,
>  > +       .hw_value = 3| (1<<4),
>  > +       .flags = IEEE80211_CCK_RATE_11MB_MASK },
>  > +     { .bitrate = 60,
>  > +       .hw_value = 4| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_6MB_MASK },
>  > +     { .bitrate = 90,
>  > +       .hw_value = 5| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_9MB_MASK },
>  > +     { .bitrate = 120,
>  > +       .hw_value = 6| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_12MB_MASK },
>  > +     { .bitrate = 180,
>  > +       .hw_value = 7| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_18MB_MASK },
>  > +     { .bitrate = 240,
>  > +       .hw_value = 8| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_24MB_MASK },
>  > +     { .bitrate = 360,
>  > +       .hw_value = 9| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_36MB_MASK },
>  > +     { .bitrate = 480,
>  > +       .hw_value = 10| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_48MB_MASK },
>  > +     { .bitrate = 540,
>  > +       .hw_value = 11| (1<<4),
>  > +       .flags = IEEE80211_OFDM_RATE_54MB_MASK },
>  > +};
>  > +
>  > +static const struct ieee80211_channel mrv_channels[] = {
>  > +     { .chan = 1,
>  > +       .freq = 2412},
>  > +     { .chan = 2,
>  > +       .freq = 2417},
>  > +     { .chan = 3,
>  > +       .freq = 2422},
>  > +     { .chan = 4,
>  > +       .freq = 2427},
>  > +     { .chan = 5,
>  > +       .freq = 2432},
>  > +     { .chan = 6,
>  > +       .freq = 2437},
>  > +     { .chan = 7,
>  > +       .freq = 2442},
>  > +     { .chan = 8,
>  > +       .freq = 2447},
>  > +     { .chan = 9,
>  > +       .freq = 2452},
>  > +     { .chan = 10,
>  > +       .freq = 2457},
>  > +     { .chan = 11,
>  > +       .freq = 2462},
>  > +     { .chan = 12,
>  > +       .freq = 2467},
>  > +     { .chan = 13,
>  > +       .freq = 2472},
>  > +     { .chan = 14,
>  > +       .freq = 2484}
>  > +};
>  > +*/
>  > +
>  > +struct mrv_rx_descriptor {
>  > +     u8      drvowner;
>  > +     u8      rssi;
>  > +     u8      status;                 /* Need to be set to 1 */
>  > +     u8      chan;
>  > +     __le16  datalen;
>  > +     u8      rsvd0;
>  > +     u8      rate;
>  > +     __le32  dma_data;               /* Point to the dma buffer use to transfer the data */
>  > +     __le32  dma_next;               /* Point to the next dma buffer to transfer control data */
>  > +     __le16  qos;
>  > +     __le16  rsvd1;
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_tx_descriptor {
>  > +     __le16  status;
>  > +     __le16  fwowner;
>  > +     u8      rate;
>  > +     u8      priority;
>  > +     __le16  qos;
>  > +     __le32  dma_addr;
>  > +     __le16  len;
>  > +     u8      dest_addr[6];
>  > +     __le32  dma_next;
>  > +     __le32  rsvd0;
>  > +     __le32  rsvd1;
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_priv {
>  > +     struct pci_dev *pdev;
>  > +     struct ieee80211_hw *dev;
>  > +     void *bar1;
>  > +     unsigned long bar1_phys;
>  > +     void *bar2;
>  > +     unsigned long bar2_phys;
>  > +
>  > +     u8 *cmd_virt;
>  > +     dma_addr_t cmd_dma;
>  > +     __le32 *magic_virt;
>  > +     dma_addr_t magic_dma;
>  > +
>  > +     int cmd_status;
>  > +     struct semaphore cmd_sem;
>  > +
>  > +     struct tasklet_struct mrv_rx_tasklet;
>  > +     struct tasklet_struct mrv_tx_cb_tasklet;
>  > +     spinlock_t irq_th_lock;
>  > +     spinlock_t tx_lock;
>  > +     wait_queue_head_t wait_command_queue;
>  > +
>  > +     int AntNum;
>  > +     int FwVer;
>  > +     int HwVer;
>  > +     int TxRingNum;
>  > +     int RegionCode;
>  > +     int TxHwDma0;
>  > +     int TxHwDma1;
>  > +     int TxHwDma2;
>  > +     int TxHwDma3;
>  > +     int RxHwDmaR;
>  > +     int RxHwDmaW;
>  > +
>  > +     struct sk_buff *rx_skb[MRV_RX_DESC_NUM];
>  > +     struct mrv_rx_descriptor *rx_ring_virt[MRV_RX_DESC_NUM];
>  > +     dma_addr_t rx_ring_dma[MRV_RX_DESC_NUM];
>  > +     int rx_idx;
>  > +
>  > +     struct sk_buff *tx_skb[MRV_TX_DESC_NUM];
>  > +     struct mrv_tx_descriptor *tx_ring_virt[MRV_TX_DESC_NUM];
>  > +     dma_addr_t tx_ring_dma[MRV_TX_DESC_NUM];
>  > +     int tx_w_idx;
>  > +     int tx_r_idx;
>  > +     int tx_pending;
>  > +
>  > +     u8 bssid[ETH_ALEN];
>  > +     int mode;
>  > +     int fw_load;
>  > +     int up;
>  > +
>  > +  struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
>  > +  struct mrv_hw *mh;
>  > +  struct ieee80211_rate rates[12];
>  > +  struct ieee80211_channel channels[14];
>  > +};
>  > +
>  > +static inline unsigned int mrv_reg_read8(struct mrv_priv *priv,
>  > +                                      unsigned int reg)
>  > +{
>  > +     return readb(priv->bar2 + reg);
>  > +}
>  > +static inline unsigned int mrv_reg_read16(struct mrv_priv *priv,
>  > +                                       unsigned int reg)
>  > +{
>  > +     return readw(priv->bar2 + reg);
>  > +}
>  > +static inline unsigned int mrv_reg_read32(struct mrv_priv *priv,
>  > +                                       unsigned int reg)
>  > +{
>  > +     return readl(priv->bar2 + reg);
>  > +}
>  > +
>  > +static inline void mrv_reg_write8(struct mrv_priv *priv,
>  > +                               unsigned int reg,
>  > +                               __le32 value)
>  > +{
>  > +     writeb(value, (void *)(priv->bar2 + reg));
>  > +}
>  > +static inline void mrv_reg_write16(struct mrv_priv *priv,
>  > +                                unsigned int reg,
>  > +                                __le32 value)
>  > +{
>  > +     writew(value, (void *)(priv->bar2 + reg));
>  > +}
>  > +static inline void mrv_reg_write32(struct mrv_priv *priv,
>  > +                                unsigned int reg,
>  > +                                __le32 value)
>  > +{
>  > +     writel(value, (void *)(priv->bar2 + reg));
>  > +}
>  > +
>  > +static inline unsigned int mrv_mem_read8(struct mrv_priv *priv,
>  > +                                      unsigned int reg)
>  > +{
>  > +     return readb(priv->bar1 + reg);
>  > +}
>  > +static inline unsigned int mrv_mem_read16(struct mrv_priv *priv,
>  > +                                       unsigned int reg)
>  > +{
>  > +     return readw(priv->bar1 + reg);
>  > +}
>  > +static inline unsigned int mrv_mem_read32(struct mrv_priv *priv,
>  > +                                       unsigned int reg)
>  > +{
>  > +     return readl(priv->bar1 + reg);
>  > +}
>  > +
>  > +static inline void mrv_mem_write8(struct mrv_priv *priv,
>  > +                               unsigned int reg,
>  > +                               __le32 value)
>  > +{
>  > +     writeb(value, (void *)(priv->bar1 + reg));
>  > +}
>  > +static inline void mrv_mem_write16(struct mrv_priv *priv,
>  > +                                unsigned int reg,
>  > +                                __le32 value)
>  > +{
>  > +     writew(value, (void *)(priv->bar1 + reg));
>  > +}
>  > +static inline void mrv_mem_write32(struct mrv_priv *priv,
>  > +                                unsigned int reg,
>  > +                                __le32 value)
>  > +{
>  > +     writel(value, (void *)(priv->bar1 + reg));
>  > +}
>  > +static inline void mrv_reg_mb(struct mrv_priv *priv)
>  > +{
>  > +     mb();
>  > +     mrv_reg_read8(priv, 0);
>  > +}
>  > +
>  > +struct mrv_cmd_hdr {
>  > +     __le16 type;
>  > +     __le16 len;
>  > +     __le16 sq;
>  > +     __le16 status;
>  > +} __attribute__ ((packed));
>  > +
>  > +struct mrv_cmd_get_config {
>  > +     __le16  HwVer;
>  > +     __le16  TxRingNum;
>  > +     __le16  MCastAdrNum;
>  > +     u8      MacAdr[6];
>  > +     __le16  RegionCode;
>  > +     __le16  AntNum;
>  > +     __le32  FwVer;
>  > +     __le32  TxRing0;
>  > +     __le32  RxRingW;
>  > +     __le32  RxRingR;
>  > +     __le32  Magic;
>  > +     __le32  TxRing1;
>  > +     __le32  TxRing2;
>  > +     __le32  TxRing3;
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_channel {
>  > +     __le16  flag;
>  > +     u8      ch;
>  > +  /* __le16 rftype;
>  > +     __le16 rsvd0;
>  > +     u8      chlist[32];*/
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_antenna {
>  > +     __le16  rtx;
>  > +     __le16  param;
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_radio {
>  > +     __le16  flag;
>  > +     __le16  preamble;
>  > +     __le16  enable;
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_rates {
>  > +     u8      fixedrate;
>  > +     u8      fixedindex;
>  > +     u8      rates[14];
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_mac_addr {
>  > +     u8      addr[6];
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_txpower {
>  > +     __le16  action;
>  > +     __le16  txpower;
>  > +     __le16  currentpowerlvl;
>  > +     __le16  rsvd;
>  > +     __le16  powers[8];
>  > +} __attribute__((packed));
>  > +
>  > +struct mrv_cmd_set_rts_threshold{
>  > +     __le32  threshold;
>  > +} __attribute__((packed));
>  > +
>  > +
>  > +struct mrv_cmd_set_slot {
>  > +     __le16  action;
>  > +     u8      shortslot;
>  > +} __attribute__ ((packed));
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
